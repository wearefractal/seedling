module.exports =
  appName: "seedling"
  port: process.env.PORT or 8080
  database: process.env.MONGODB or "mongodb://localhost/#{@appName}"
  paths:
    models: './models'