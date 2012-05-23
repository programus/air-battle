MAX_UNIT = 10
MAX_DIR = 4
AIRCRAFT_NUM = 3

# Aircraft class
cAircraft = (_x, _y, _d)->
	body = []
	cells = []
	deltas = [
		[
			[0  , 0 ]
			[-2 , 1 ]
			[-1 , 1 ]
			[0  , 1 ]
			[1  , 1 ]
			[2  , 1 ]
			[0  , 2 ]
			[-1 , 3 ]
			[0  , 3 ]
			[1  , 3 ]
		]
		[
			[0  , 0  ]
			[-1 , -2 ]
			[-1 , -1 ]
			[-1 , 0  ]
			[-1 , 1  ]
			[-1 , 2  ]
			[-2 , 0  ]
			[-3 , -1 ]
			[-3 , 0  ]
			[-3 , 1  ]
		]
		
		[
			[0  , 0  ]
			[-2 , -1 ]
			[-1 , -1 ]
			[0  , -1 ]
			[1  , -1 ]
			[2  , -1 ]
			[0  , -2 ]
			[-1 , -3 ]
			[0  , -3 ]
			[1  , -3 ]
		]
		[
			[0 , 0  ]
			[1 , -2 ]
			[1 , -1 ]
			[1 , 0  ]
			[1 , 1  ]
			[1 , 2  ]
			[2 , 0  ]
			[3 , -1 ]
			[3 , 0  ]
			[3 , 1  ]
		]
	]

	validNum = (n, target) -> 0 <= n < if target == "d" then MAX_DIR else MAX_UNIT
	gsetNum = (param, member, target)->
		if param?
			if not isFinite(param)
				throw e =
					reason: "Not numeric"
					message: "The parameter must be a integer"
					target: target
					param: param
			if not validNum param, target
				throw e =
					reason: "InvalidParam"
					message: "Number out of range"
					target: target
					param: param
			else
				member = param
		member

	generateBody = ->
		body = []
		cells = []
		if _x? && _y? && _d?
			for delta in deltas[_d]
				x = _x + delta[0]
				y = _y + delta[1]
				if 0 <= x < MAX_UNIT && 0 <= y < MAX_UNIT
					body.push [x, y]
					cells[x * 10 + y] = if delta[0] == 0 && delta[1] == 0 then 'X' else 'O'
				else
					throw e =
						reason: "InvalidLocation"
						message: "Number out of range"
						target: "(#{delta[0]}, #{delta[1]})"
						param: "(#{_x}, #{_y}, #{_d})"
		body

	_x = gsetNum _x, _x, "x"
	_y = gsetNum _y, _y, "y"
	_d = gsetNum (if _d? then _d % 4 else _d), _d, "d"
	# generate body when constructed.
	generateBody()

	# The return object
	ac =
		x: (__x)->
			_x = gsetNum __x, _x, "x"
			if __x? then generateBody()
			_x
		y: (__y)->
			_y = gsetNum __y, _y, "y"
			if __y? then generateBody()
			_y
		d: (__d)->
			_d = gsetNum (if __d? then __d % 4 else __d), _d, "d"
			if __d? then generateBody()
			_d
		xyd: (__x, __y, __d) ->
			_x = gsetNum __x, _x, "x"
			_y = gsetNum __y, _y, "y"
			_d = gsetNum (if __d? then __d % 4 else __d), _d, "d"
			if __x? || __y? || __d? then generateBody()
			_return =
				x: _x
				y: _y
				d: _d
		body: -> body
		cells: -> cells
		toInt: -> _x * 100 + _y * 10 + _d
		toString: -> "(#{_x}, #{_y}): #{"k>j<"[_d]}"
		toMap: ->
			map = (
				(' ' + (cells[x * 10 + y] ? '.') for x in [0..(MAX_UNIT - 1)])
					.join('') for y in [0..(MAX_UNIT - 1)]).join('\n')

# static method
cAircraft.parse = (s) ->
	n = parseInt(s)
	d = n % 10
	y = ((n / 10) | 0) % 10
	x = ((n / 100) | 0) % 10
	cAircraft(x, y, d)


# layout class. A layout contains 3 aircrafts
cLayout = (_aircrafts...)->
	cells = []
	setAircraft = (param) ->
		if _aircrafts.length == 1
			_aircrafts = _aircrafts[0][..(AIRCRAFT_NUM - 1)]

	setAircraft(_aircrafts)

	# the return object
	layout =
		aircrafts: (__a) ->
			if __a?
				setAircraft(__a)
			_aircrafts
		push: (a) -> _aircrafts.push(a)
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
		cells: -> cells
		toStorageInt: ->
			num = 0
			for a, i in _aircrafts.sort((a, b) -> a.toInt() - b.toInt())
				if i < AIRCRAFT_NUM
					num = num * 1000 + a.toInt()
			num

		toStorageString: ->
			num = @toStorageInt()
			String.fromCharCode(num >> 16) + String.fromCharCode(num & 0xFFFF)

		toMap: ->
			if cells.length <= 0
				"Call isValid() to fill cell information"
			else
				map = (
					(' ' + (cells[x * 10 + y] ? '.') for x in [0..(MAX_UNIT - 1)])
						.join('') for y in [0..(MAX_UNIT - 1)]).join('\n')

# static method
cLayout.parse = (s) ->
	n = if isFinite(s) then parseInt(s) else (s.charCodeAt(0) << 16) + s.charCodeAt(1)
	as = []
	for i in [1..AIRCRAFT_NUM]
		as.splice(0, 0, cAircraft.parse(n % 1000))
		n = (n / 1000) | 0
	cLayout(as)

root = exports ? this
root.cAircraft = cAircraft
root.cLayout = cLayout

