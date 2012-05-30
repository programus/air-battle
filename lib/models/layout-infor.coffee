cLayout   = require 'layout'
cAircraft = require 'aircraft'
db = require '../db'

cLayoutInfor = ->

  dbdata = (li) ->
    _data =
      l: li.layout.toStorageInt()
      m: li.master
      c: li.contributors

  layoutInfor =
    layout: cLayout()
    masters: []
    contributors: []
    save: (callback) ->
      if @layout.isValid()
        db.save(dbdata(@), callback)

cLayoutInfor.load = (layoutInt, callback) ->
  db.findOne {l: layoutInt}, (err, docs) ->
    if ! err?
      li = cLayoutInfor()
      li.layout = cLayout.parse docs.l
      li.masters = docs.m
      li.contributors = docs.c
    else
      li = null
     callback(err, li)
