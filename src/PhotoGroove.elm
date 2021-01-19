module PhotoGroove exposing (main, randomPhotoPicker, Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Browser
import Array exposing (Array)
import Random exposing (int)
import Random

type Status
    = Loading
    | Loaded (List Photo) String
    | Errored String
type ThumbnailSize
    = Small
    | Medium
    | Large

type Msg
    = ClickedPhoto  String
    | GotSelectedIndex Int
    | ClickedSize ThumbnailSize
    | ClickedSurpriseMe

type alias Photo =
    {url : String}

type alias Model = 
    { status : Status
    , chosenSize : ThumbnailSize
    }




urlPrefix : String
urlPrefix = "http://elm-in-action.com/"

view : Model -> Html Msg
view model = 
    div [class "content"]
    [h1 [] [text "Photo Groove"]
    , button 
        [ onClick ClickedSurpriseMe]
        [ text "Suprise Me!"]
    , h3 [] [text "Thumbnail Sizes:"]
    , div [ id "choose-size"]
        (List.map (viewSizeChooser model.chosenSize) [Small,  Medium,  Large])
    , div [id "thumbnails", class (sizeToString model.chosenSize)] 
        (List.map (viewThumbnail model.selectedUrl) model.photos)
    , img
        [ class "large"
        , src (urlPrefix ++ "large/" ++ model.selectedUrl)
        ]
        []
    
    ]



viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb = 
    img
        [src (urlPrefix ++ thumb.url)
        , classList [("selected", selectedUrl == thumb.url)]
        , onClick (ClickedPhoto thumb.url)
        ]
        []


viewSizeChooser : ThumbnailSize -> ThumbnailSize -> Html Msg
viewSizeChooser current_size size = 
    label []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size), checked (current_size == size) ] []
        , text (sizeToString size)
        ]

sizeToString : ThumbnailSize -> String
sizeToString size = 
    case size of 
        Small -> "small"
        Medium -> "med"
        Large -> "large"

initialModel : Model
initialModel =   
    { status = Loading
    , chosenSize = Medium
    }

randomPhotoPicker : Random.Generator Int 
randomPhotoPicker = 
    Random.int 0 (Array.length photoArray - 1)

photoArray: Array Photo
photoArray =
    Array.fromList initialModel.photos

getPhotoUrl : Int -> String
getPhotoUrl index = 
    case Array.get index photoArray of 
        Just photo -> photo.url 
        Nothing -> ""    

update: Msg -> Model -> ( Model, Cmd Msg)
update msg model = 
    case msg of
        GotSelectedIndex index -> 
                ( { model | selectedUrl = getPhotoUrl index}, Cmd.none)
        ClickedPhoto photo-> 
                ( {model | selectedUrl = photo }, Cmd.none)
        ClickedSize size ->
                ({model | chosenSize = size}, Cmd.none)
        ClickedSurpriseMe -> 
                ( model, Random.generate GotSelectedIndex randomPhotoPicker)

main: Program () Model Msg
main = 
    Browser.element
        { init = \flags -> (initialModel, Cmd.none)
        , view = view 
        , update = update 
        , subscriptions = \model -> Sub.none
        }