db = require '../db'

cUserInfor = ->

  dbdata = (ui) ->
    _data =
      i: ui.uid
      w: ui.password
      m: ui.mail
      p: ui.point

  UserInfor =
    uid: null
    password: null
    mail: null
    point: null
    save: (callback) ->
      db.save(dbdata(@), callback)
