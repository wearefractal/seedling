path = require 'path'
appName = "seedling"
module.exports =
  appName: appName
  port: process.env.PORT or 8080
  db:
  	url: process.env.MONGODB or "mongodb://localhost/#{appName}"
  paths:
    models: path.resolve './test/models/*'
