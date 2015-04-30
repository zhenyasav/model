
Tinytest.add 'model - save new', (test) ->
	model = new Fubar
		foo: 'bar'
	model.save()
	test.isTrue typeof model._id is 'string' and model._id, '_id is a nonempty string'
	dbrecord = Fubars.findOne model._id
	test.isTrue dbrecord.foo is 'bar', 'dbrecord value set'


Tinytest.addAsync 'model - update', (test, next) ->
	model = new Fubar
		foo: 'bar'
	
	model.save()

	model.update
		$set:
			bar: 'foo'
		$unset:
			foo: ''
	, (err, cont) ->
		test.fail err if err?

		test.isTrue model.bar is 'foo', 'model value set'
		test.isTrue model.foo is undefined, 'model value unset'

		dbrecord = Fubars.findOne model._id

		test.isTrue dbrecord.bar is 'foo', 'record value set'
		test.isTrue dbrecord.foo is undefined, 'record value unset'

		next()


Tinytest.addAsync 'model - change and save', (test, next) ->
	model = new Fubar
		foo: 'bar'
	model.save()
	delete model.foo
	model.bar = 'foo'
	model.save (err, res) =>
		test.fail err if err?
		dbrecord = Fubars.findOne model._id
		test.isNotNull dbrecord, 'dbrecord is not null'
		test.isTrue dbrecord.bar is 'foo', 'dbrecord value set'
		test.isTrue dbrecord.foo is undefined, 'dbrecord value unset'
		next()



