# Test suites for all models

models = require '../models'

# Air-craft class
cAircraft = models.cAircraft

describe 'Test Suite for Aircraft class', ->
	for d in [0..3]

	it 'should construct a new aircraft with x, y, d', ->
		a = cAircraft(
