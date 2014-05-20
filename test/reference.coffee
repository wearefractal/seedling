seedling = require '../'
should   = require 'should'
config   = require './config/config'
goose    = require 'goosestrap'

module.exports =

  "functions should get ref to seedling": ->

    db = goose config.db.url, config.paths.models
    User = db.model 'User'

    seeds =
      User: (seed) ->

        # seedling
        seed.should.have.property 'ref'

        username: 'admin'
        id: '1'
        token: '1'
        password: 'secret'

    seed = new seedling db, seeds

    seed.create (err) ->
      should.not.exist err

