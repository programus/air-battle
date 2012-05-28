MAX_UNIT = 10
MAX_DIR = 4

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
				throw new Error("The parameter, #{target}, must be an integer: #{param}")
			if not validNum param, target
				throw new Error("Number out of range: #{target} = #{param}")
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
					throw new Error("Number out of range: aircraft(#{_x},#{_y},#{_d}) -> (#{delta[0]},#{delta[1]})")
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
			map = " #{(' ' + _i for _i in [0..(MAX_UNIT - 1)]).join('')}\n" + (
				y + (' ' + (cells[x * 10 + y] ? '.') for x in [0..(MAX_UNIT - 1)])
					.join('') for y in [0..(MAX_UNIT - 1)]).join('\n')

# static methods
cAircraft.parse = (s) ->
	n = parseInt(s)
	d = n % 10
	y = ((n / 10) | 0) % 10
	x = ((n / 100) | 0) % 10
	cAircraft(x, y, d)

cAircraft.sort = (a, b) ->
	a.toInt() - b.toInt()

cAircraft.MAX_UNIT = -> MAX_UNIT
cAircraft.MAX_DIR = -> MAX_DIR

root = exports ? this
root.cAircraft = cAircraft
