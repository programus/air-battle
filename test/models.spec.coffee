# Test suites for all models
chai = require 'chai'
should = chai.should()
_u = require 'underscore'

models = require('../req') 'models'

# Air-craft class
cAircraft = models.cAircraft
ranges = [
	{
		x: [2..7]
		y: [0..6]
	}
	{
		x: [3..9]
		y: [2..7]
	}
	{
		x: [2..7]
		y: [3..9]
	}
	{
		x: [0..6]
		y: [2..7]
	}
]
deltas = [
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

ad_delta = [
	{
		ix: 0
		iy: 1
		px: 1
		py: 1
	}
	{
		ix: 1
		iy: 0
		px: -1
		py: 1
	}
	{
		ix: 0
		iy: 1
		px: -1
		py: -1
	}
	{
		ix: 1
		iy: 0
		px: 1
		py: -1
	}
]

# a sort function for sort array which elements are number arrays.
asort = (a, b)->
	for x in _u.zip(a, b)
		d = x[0] - x[1]
		return d if d != 0
	return 0

describe 'cAircraft.', ->
	for d in [0...8]
		for x in [0..9]
			for y in [0..9]
				((x, y, d)->
					index = d % 4
					a = null
					aInt = x * 100 + y * 10 + index
					if x in ranges[index].x && y in ranges[index].y
						describe 'normal cases:', ->
							describe '#constructors', ->
								it "should construct a new aircraft with x=#{x}, y=#{y}, d=#{d}", ->
									(-> a = cAircraft(x, y, d)).should.not.throw(Error)
							describe 'static #parse()', ->
								it "should parse to a new aircraft from #{aInt}", ->
									(-> a = cAircraft.parse(aInt)).should.not.throw(Error)
								it "should parse to a new aircraft from '#{aInt}'", ->
									(-> a = cAircraft.parse(aInt.toString())).should.not.throw(Error)
							describe '#x() get', ->
								it "should be x=#{x}", ->
									a.x().should.eql(x)
							describe '#y() get', ->
								it "should be y=#{y}", ->
									a.y().should.eql(y)
							describe '#d() get', ->
								it "should be d=#{index}", ->
									a.d().should.eql(index)
							describe '#xyd() get', ->
								it "should be {x: #{x}, y: #{y}, d: #{index}}", ->
									a.xyd().should.eql(
										x: x
										y: y
										d: index
									)
							describe '#body()', ->
								it "should be a body with 10 cells", ->
									a.body().length.should.eql(10)
								it "should be follow the body pattern - #{x}, #{y}, #{d}", ->
									a.body().sort(asort).should.eql(([
										x + deltas[i][ad_delta[index].ix] * ad_delta[index].px
										y + deltas[i][ad_delta[index].iy] * ad_delta[index].py
									] for i in [0...a.body().length]).sort(asort))
							describe '#cells()', ->
								it "cells should be marked correctly - #{x}, #{y}, #{d}", ->
									a.cells()[xy[0] * 10 + xy[1]]
										.should.eql(if xy[0] == x && xy[1] == y then 'X' else 'O') for xy, i in a.body()
							describe '#toInt()', ->
								it "should in a correct int - #{x}, #{y}, #{d}", ->
									a.toInt().should.eql(x * 100 + y * 10 + index)
							describe '#toString()', ->
								it "should return a string - #{x}, #{y}, #{d}", ->
									a.toString().should.eql("(#{x}, #{y}): #{"k>j<"[index]}")
							describe '#toMap()', ->
								it "should get a correct map - #{x}, #{y}, #{d}", ->
									map = a.toMap()
									cells = a.cells()
									map[(_y + 1) * 22 + _x * 2 + 2].should.eql(cells[_x * 10 + _y] ? '.') for _y in [0..9] for _x in [0..9]
					else
						describe 'exception cases for out range numbers:', ->
							describe '#constructors', ->
								it "should throw an exception. (#{x}, #{y}, #{d})", ->
									try
										a = cAircraft(x, y, d)
									catch e
										e.should.be.instanceof(Error)
										e.message.should.have.string "Number out of range: aircraft(#{x},#{y},#{index}) -> "
							describe 'static #parse()', ->
								it "should throw an exception when parsing. (#{aInt})", ->
									try
										a = cAircraft.parse(aInt)
									catch e
										e.should.be.instanceof(Error)
										e.message.should.have.string "Number out of range: aircraft(#{x},#{y},#{index}) -> "
								it "should throw an exception when parsing. ('#{aInt}')", ->
									try
										a = cAircraft.parse(aInt.toString())
									catch e
										e.should.be.instanceof(Error)
										e.message.should.have.string "Number out of range: aircraft(#{x},#{y},#{index}) -> "
				)(x, y, d)

	describe 'special cases:', ->
		a = null
		v = null
		describe 'constructed without args:', ->
			describe '#constructor', ->
				it "should no error", ->
					(-> a = cAircraft()).should.not.throw(Error)
				it "should be all undefined", ->
					a.xyd().should.eql(
						x: undefined
						y: undefined
						d: undefined
					)
			describe '#x()', ->
				it "should be set x correctly", ->
					a = cAircraft()
					v = (Math.random() * 10) | 0
					a.x(v).should.eql v
				it "should still be the value", ->
					a.x().should.eql v
				it "should be an range exception because of wrong x", ->
					a = cAircraft()
					for wx in [-3, -1, 10, 20]
						try
							a.x(wx)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "Number out of range: x = #{wx}"
				it "should be an number exception because of wrong x", ->
					a = cAircraft()
					for wx in ['a', {
						a: 'a'
						b: 'b'
					}, /test/]
						try
							a.x(wx)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "The parameter, x, must be an integer: #{wx}"
			describe '#y()', ->
				it "should be set y correctly", ->
					a = cAircraft()
					v = (Math.random() * 10) | 0
					a.y(v).should.eql v
				it "should still be the value", ->
					a.y().should.eql v
				it "should be an range exception because of wrong y", ->
					a = cAircraft()
					for wy in [-3, -1, 10, 20]
						try
							a.y(wy)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "Number out of range: y = #{wy}"
				it "should be an number exception because of wrong y", ->
					a = cAircraft()
					for wy in ['a', {
						a: 'a'
						b: 'b'
					}, /test/]
						try
							a.y(wy)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "The parameter, y, must be an integer: #{wy}"
			describe '#d()', ->
				it "should be set d correctly", ->
					a = cAircraft()
					v = (Math.random() * 100) | 0
					a.d(v).should.eql(v % 4)
					v = v % 4
				it "should still be the value", ->
					a.d().should.eql v
				it "should be an range exception because of wrong d", ->
					a = cAircraft()
					for wd in [-3, -1]
						try
							a.d(wd)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "Number out of range: d = #{wd}"
				it "should be an number exception because of wrong d", ->
					a = cAircraft()
					for wd in ['a', {
						a: 'a'
						b: 'b'
					}, /test/]
						try
							a.d(wd)
						catch e
							e.should.be.instanceof(Error)
							e.message.should.eql "The parameter, d, must be an integer: NaN"
			describe '#xyd()', ->
				it "should set xyd correctly", ->
					a = cAircraft()
					x = 3
					y = 3
					d = 0
					a.xyd(x, y, d).should.eql(
						x: x
						y: y
						d: d
					)
				it "should be the value", ->
					a.xyd().should.eql(
						x: x
						y: y
						d: d
					)
		describe '#sort()', ->
			it 'should be sorted', ->
				inputArray = [
					540
					361
					200
					463
					772
				]
				airArray = _u.map(inputArray, cAircraft.parse)
				sortedNumbers = inputArray.sort()
				_u.map(airArray.sort(cAircraft.sort), (a)-> a.toInt()).should.eql sortedNumbers

# Layout class
cLayout = models.cLayout

testData = [
	{
		as: [
			cAircraft(2, 3, 0)
			cAircraft(7, 3, 0)
			cAircraft(5, 8, 2)
		]
		inputInt: 230730582
		outputInt: 230582730
		valid: true
	}
	{
		as: [
			cAircraft(0, 3, 3)
			cAircraft(8, 3, 1)
			cAircraft(3, 5, 3)
		]
		inputInt: 33831353
		outputInt: 33353831
		valid: true
	}
	{
		as: [
			cAircraft(2, 3, 0)
			cAircraft(7, 3, 0)
			cAircraft(5, 7, 2)
		]
		inputInt: 230730572
		outputInt: 230572730
		valid: false
	}
	{
		as: [
			cAircraft(0, 3, 3)
			cAircraft(8, 3, 1)
			cAircraft(2, 5, 3)
		]
		inputInt: 33831253
		outputInt: 33253831
		valid: false
	}
]

describe 'cLayout.', ->
	for d in testData
		((data) ->
			describe "(input:#{data.inputInt})", ->
				layout = null
				describe "#constructors", ->
					it "should construct a layout by aircrafts", ->
						(-> layout = cLayout(data.as[0], data.as[1], data.as[2])).should.not.throw(Error)
					it "should construct a layout by a aircraft array", ->
						(-> layout = cLayout(data.as)).should.not.throw Error
				describe "#aircrafts() get", ->
					it "should be the same aircraft array", ->
						convInt = (a) -> a.toInt()
						_u.map(layout.aircrafts(), convInt).should.eql _u.map(data.as, convInt)
				describe "#aircrafts() set", ->
					it "should be set by shuffled aircraft array", ->
						aa = _u.shuffle data.as
						lo = cLayout data.as
						lo.aircrafts aa
						convInt = (a) -> a.toInt()
						_u.map(lo.aircrafts(), convInt).should.eql _u.map(aa, convInt)
				describe "#cells()", ->
					it "should be a sum of aircrafts", ->
						layout.aircrafts().push cAircraft(4, 0, 0)
						if data.valid
							_u.compact(layout.cells()).length.should.eql 30
						else
							layout.cells().should.eql ['']
				describe "#isValid()", ->
					it "should be #{data.valid}", ->
						layout.isValid().should.eql data.valid
				describe "#toStorageInt()", ->
					it "should return an integer with the expected value: #{data.outputInt}", ->
						layout.toStorageInt().should.eql data.outputInt
				describe "#toStorageString()", ->
					it "should return a string with the expected value", ->
						str = layout.toStorageString()
						((str.charCodeAt(0) << 16) + str.charCodeAt(1)).should.eql data.outputInt
				describe "static #parse()", ->
					it "should return a layout by an integer: #{data.inputInt}", ->
						(-> layout = cLayout.parse(data.inputInt)).should.not.throw Error
					it "should return a layout by a string", ->
						str = layout.toStorageString()
						(-> layout = cLayout.parse(str)).should.not.throw Error
				describe '#toMap()', ->
					it "should get a correct map", ->
						if data.valid
							map = layout.toMap()
							cells = layout.cells()
							map[(_y + 1) * 22 + _x * 2 + 2].should.eql(cells[_x * 10 + _y] ? '.') for _y in [0..9] for _x in [0..9]
		)(d)
