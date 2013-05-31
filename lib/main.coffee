async    = require 'async'
{Schema} = require 'mongoose'

module.exports =
  
  class Seedling
    constructor: (@db, @models) -> @collection = {}

    clear: (cb) ->
      async.parallel (m.remove.bind m for _, m of @db.models), cb

    create: (cb) ->

      async.eachSeries Object.keys(@models), (name, done) =>
        type = @db.model name
        data = @models[name]
        @collection[name] = []
        data = data() if data instanceof Function
        async.each data, (model, next) =>
          type.create model, (err, res) => 
            if err? then console.log "err: #{err}"
            @collection[name].push res
            next()
        , (err) ->
          console.log err if err?
          done()
   
      , (err) ->
        console.log err if err?
        cb()

    rand: (model) -> @collection[model][Math.floor(Math.random()*@collection[model].length)]

    ref: (model) -> 
      # just ObjectId
      return @rand(model)._id

    embed: (model) ->
      # randomize
      return @rand(model)
