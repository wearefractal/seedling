seedling = require '../'
should   = require 'should'
config   = require './config/config'
goose    = require 'goosestrap'

module.exports =

  "functions should get access to 'sandbox'": ->

    db = goose config.db.url, config.paths.models
    User = db.model 'User'

    seeds =
      User: (seed, sandbox) ->

        # sandbox
        sandbox.FB_USER.should.equal 'myfb.user'

        username: 'admin'
        id: '1'
        token: '1'
        password: 'secret'

    seed = new seedling db, seeds,
      FB_USER: 'myfb.user'

    seed.create (err) ->
      should.not.exist err

