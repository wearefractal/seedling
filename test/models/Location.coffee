{Schema} = require 'mongoose'

Location = new Schema
  name:
    type: String
    required: true
  coords:
    lat: 
      type: Number
      required: true
    lon: 
      type: Number
      required: true


module.exports = Location