async    = require 'async'
{Schema} = require 'mongoose'
Hookify  = require 'hookify'
_        = require 'lodash'

module.exports =

  class Seedling extends Hookify
    constructor: (@db, @models, @sandbox) ->
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
          data = data(@, @sandbox) if data instanceof Function
          async.eachSeries data, (model, next) =>
            for k, v of model
              model[k] = v(@, @sandbox) if v instanceof Function
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

    randCache: []

    rand: (model, {filter, blacklist, allowDupes}) ->

      list = @collection[model]

      # DUPLICATES OR NAH
      if !allowDupes
        list = list?.filter (item) =>
          for dupe in @randCache
            if _.isEqual item, dupe
              return false
              break
          return true

      # USER filter query
      if filter?
        list = list?.filter filter

      # BLACKLIST
      if blacklist?
        list = list?.filter (item) ->
          for black in blacklist
            if item._id is black
              return false
              break
          return true

      # derive item
      item = list[Math.floor(Math.random()*list?.length)]

      # cache item
      @randCache.push item

      return item

    ref: (model, query) ->
      result = null
      if query?
        result = (_.find(@collection[model], query))?._id
      else
        # just ObjectId
        result = @rand(model)._id

      return result

    embed: (model, query) ->
      if query?
        return (_.find @collection[model], query)
      else
        # randomize
        return @rand(model)
