async    = require 'async'
{Schema} = require 'mongoose'
Hookify  = require 'hookify'
_        = require 'lodash'

module.exports =
  
  class Seedling extends Hookify
    constructor: (@db, @models) ->
      super()
      @collection = {}

    clear: (cb) ->
      @runPre "clear", [], (err) =>
        return cb err if err?
        async.parallel (m.remove.bind m for __, m of @db.models), (err) =>
          @runPost "clear", [], cb

    create: (cb) ->
      @runPre "create", [], (err) =>
        return cb err if err?
        async.eachSeries Object.keys(@models), (name, done) =>
          type = @db.model name
          data = @models[name]
          @collection[name] = []
          data = data() if data instanceof Function
          async.eachSeries data, (model, next) =>
            for k, v of model
              model[k] = v() if v instanceof Function
            type.create model, (err, res) =>
              if err? then console.log "err: #{err}"
              @collection[name].push res
              next()
          , (err) ->
            console.log err if err?
            done()
     
        , (err) =>
          console.log err if err?
          @runPost "create", [], (err) ->
            console.log err if err?
            cb()

    rand: (model) -> @collection[model][Math.floor(Math.random()*@collection[model].length)]

    ref: (model, query) ->
      if query?
        return (_.find(@collection[model], query))._id
      else
        # just ObjectId
        return @rand(model)._id

    embed: (model, query) ->
      if query?
        return (_.find @collection[model], query)
      else
        # randomize
        return @rand(model)
