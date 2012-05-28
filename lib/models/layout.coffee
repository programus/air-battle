cAircraft = require('./aircraft').cAircraft

AIRCRAFT_NUM = 3

# layout class. A layout contains 3 aircrafts
cLayout = (_aircrafts...)->
	cells = []
	setAircraft = (param) ->
		if param.length == 1
			param = param[0]
		_aircrafts = param[..(AIRCRAFT_NUM - 1)]

	setAircraft(_aircrafts)

	# the return object
	layout =
		aircrafts: (__a) ->
			if __a?
				setAircraft(__a)
			_aircrafts
		isValid: ->
			cells = []
			for a, i in _aircrafts
				if i < AIRCRAFT_NUM
					for index, mark of a.cells()
						if cells[index]?
							return false
						else
							cells[index] = mark
				else
					break
			return true
		cells: ->
			if !(cells? && cells.length? && cells.length > 0)
				if !@isValid()
					cells = ['']
			cells
		toStorageInt: ->
			num = 0
			for a, i in _aircrafts[0...AIRCRAFT_NUM].sort((a, b) -> a.toInt() - b.toInt())
				if i < AIRCRAFT_NUM
					num = num * 1000 + a.toInt()
			num

		toStorageString: ->
			num = @toStorageInt()
			String.fromCharCode(num >> 16) + String.fromCharCode(num & 0xFFFF)

		toMap: ->
			_cells = @cells()
			map = " #{(' ' + _i for _i in [0..(cAircraft.MAX_UNIT() - 1)]).join('')}\n" + (
				y + (' ' + (_cells[x * 10 + y] ? '.') for x in [0..(cAircraft.MAX_UNIT() - 1)])
					.join('') for y in [0..(cAircraft.MAX_UNIT() - 1)]).join('\n')

# static method
cLayout.parse = (s) ->
	n = if isFinite(s) then parseInt(s) else (s.charCodeAt(0) << 16) + s.charCodeAt(1)
	as = []
	for i in [1..AIRCRAFT_NUM]
		as.splice(0, 0, cAircraft.parse(n % 1000))
		n = (n / 1000) | 0
	cLayout(as)

cLayout.AIRCRAFT_NUM = AIRCRAFT_NUM

root = exports ? this
root.cLayout = cLayout

