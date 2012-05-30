db = require '../lib/db'
models = require '../lib/models'
as = models.aircrafts

count = 0
completed = false

incCount = ->
	count++

decCount = ->
	count--
	if completed && count <= 0
		console.log 'saved'
		process.exit(0)

for a0, i0 in as
	for a1, i1 in as[i0 + 1..]
		for a2, i2 in as[i0 + i1 + 2..]
			layout = models.cLayout(a0, a1, a2)
			if layout.isValid()
				incCount()
				cint.save(
					l: layout.toStorageInt(), decCount)
				incCount()
				cstr.save(
					l: layout.toStorageString(), decCount)
				incCount()
				cfull.save(
					l: ({
						x: a.x()
						y: a.y()
						d: a.d()
					} for a in layout.aircrafts()), decCount)

completed = true
console.log 'Finished'

