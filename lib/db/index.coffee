mongojs = require 'mongojs'
settings = require './settings'

db = mongojs.connect settings.db, settings.collection
module.exports = db
