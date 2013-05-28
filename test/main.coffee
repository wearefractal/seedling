seedling = require '../'
should   = require 'should'
config   = require './config'
db       = require('goosestrap') config

module.exports = 
  
  "given some seed data": ->

    seed = new seedling

      User: [
        username: 'admin'
        id: '1'
        token: '1'
        password: 'secret' 
      ]

      Location: [
        name: "Scottsdale Fashion Square"
        coords: 
          lat: 33.5038 
          lon: 111.9296
      ]

      Movie: -> [
        name: "Star Trek Into Darkness"
        date: "5/15/13"
        imgUrl: "http://api.ning.com/files/K6cyghYfeIs47byqVTOkvuRkLd7EEz3FJZvL*6v*9uC3PsnxvdyZfyvxRKJbuHh4vNdtMcyCH6-V0VfdQtH9llTNpc2GR*qv/startrek_v1.jpg?size=173&crop=1:1"
        location: seed.ref 'Location'
      ,
        name: "The Iceman"
        date: "5/15/13"
        imgUrl: "http://api.ning.com/files/ysdCY8Oh2FFFqeGsBQ6Qpeb6eJZ6ytFvsVN2r0QDqPaPnwC9Lu4NQSl6Mcch4lABkVqYrX-jUoZa8xK2ccGDnXbwANQcPvf-/iceman.jpg?size=173&crop=1:1"
        location: seed.ref 'Location'
      ]

  "when seed.create is called": ->

    seed.clear ->
      seed.create (err) ->
        console.log err if err?
        err.should.not.exist()
