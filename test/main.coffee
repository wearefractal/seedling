seedling = require '../'
should   = require 'should'
config   = require './config/config'
goose    = require 'goosestrap'

module.exports =
  "given a db connection": =>
    @db = goose config.db.url, config.paths.models

  "given some seed data": =>

    @preCreateRan = false
    @preClearRan= false
    @postCreateRan = false
    @postClearRan = false
    @seed = new seedling @db,

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

      Movie: => [
        name: "Star Trek Into Darkness"
        date: "5/15/13"
        imgUrl: "http://api.ning.com/files/K6cyghYfeIs47byqVTOkvuRkLd7EEz3FJZvL*6v*9uC3PsnxvdyZfyvxRKJbuHh4vNdtMcyCH6-V0VfdQtH9llTNpc2GR*qv/startrek_v1.jpg?size=173&crop=1:1"
        location: @seed.ref 'Location'
      ,
        name: "The Iceman"
        date: "5/15/13"
        imgUrl: "http://api.ning.com/files/ysdCY8Oh2FFFqeGsBQ6Qpeb6eJZ6ytFvsVN2r0QDqPaPnwC9Lu4NQSl6Mcch4lABkVqYrX-jUoZa8xK2ccGDnXbwANQcPvf-/iceman.jpg?size=173&crop=1:1"
        location: @seed.ref 'Location', {name: "Scottsdale Fashion Square"}
      ]

  "given hooks": =>

    @seed.pre "create", (next) =>
      @preCreateRan = true
      next()

    @seed.pre "create", (next) =>
      @postCreateRan = true
      next()

    @seed.pre "clear", (next) =>
      @preClearRan = true
      next()

    @seed.pre "clear", (next) =>
      @postClearRan = true
      next()

  "create should run": (done) =>

    @seed.create (err) ->
      should.not.exist err
      done()
  
  "pre create hook should run": =>
    @preCreateRan.should.be.ok

  "post create hook should run": =>
    @postCreateRan.should.be.ok

  "seed data should exist": (done) =>

    @User     = @db.model 'User'
    @Movie    = @db.model 'Movie'
    @Location = @db.model 'Movie'

    @User.find (err, res) =>
      should.not.exist err
      res[0].username.should.equal 'admin'

      @Movie.find (err, res) ->
        should.not.exist err
        res[0].name.should.equal "Star Trek Into Darkness"
        res[1].name.should.equal "The Iceman"
        done()

  "clear should delete everything": (done) =>
    # cleanup; usually you would call first
    @seed.clear =>
      @User.find (err, res) ->
        res.should.be.empty
        done()

  "pre clear hook should run": =>
    @preClearRan.should.be.ok

  "post clear hook should run": =>
    @postClearRan.should.be.ok

