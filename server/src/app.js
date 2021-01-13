const express = require('express')
const path = require('path')

const app = express()

const port = process.env.PORT || 3001
const pucblicDirectory = path.join(__dirname,"../../client")

app.use(express.static(pucblicDirectory))


app.listen(port, () => {
    console.log("The app is listening on port " + port)
})