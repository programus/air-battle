# Test suites for all models
chai = require 'chai'
should = chai.should()
_u = require 'underscore'

models = require('../req') 'models'

# Air-craft class
cAircraft = models.cAircraft
# Layout class
cLayout = models.cLayout

# turn aircraft to int
convInt = (a) -> a.toInt()

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
						_u.map(layout.aircrafts(), convInt).should.eql _u.map(data.as, convInt)
				describe "#aircrafts() set", ->
					it "should be set by shuffled aircraft array", ->
						aa = _u.shuffle data.as
						lo = cLayout data.as
						lo.aircrafts aa
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
