path = require 'path'
module.exports =
  appName: "seedling"
  port: process.env.PORT or 8080
  db: 
  	url: process.env.MONGODB or "mongodb://localhost/#{@appName}"
  paths:
    models: path.resolve './test/models'