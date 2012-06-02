cFormation   = require 'formation'
cAircraft = require 'aircraft'
db = require '../db'

cFormationInfor = ->

  dbdata = (li) ->
    _data =
      l: li.formation.toStorageInt()
      m: li.master
      c: li.contributors

  formationInfor =
    formation: cFormation()
    masters: []
    contributors: []
    save: (callback) ->
      if @formation.isValid()
        db.save(dbdata(@), callback)

cFormationInfor.load = (formationInt, callback) ->
  db.findOne {l: formationInt}, (err, docs) ->
    if ! err?
      li = cFormationInfor()
      li.formation = cFormation.parse docs.l
      li.masters = docs.m
      li.contributors = docs.c
    else
      li = null
     callback(err, li)
