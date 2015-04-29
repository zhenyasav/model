
Tinytest.add 'model - save new', (test) ->
	model = new Fubar()
	try
		model.save()
	catch err
		test.fail err

	test.isTrue typeof model._id is 'string' and model._id, '_id is a nonempty string'


Tinytest.add 'model - update', (test) ->
	model = new Fubar
		foo: 'bar'
	
	model.save()

	model.update
		$set:
			bar: 'foo'
		$unset:
			foo: ''



Tinytest.add 'model - change and save', (test) ->
	model = new Fubar
		foo: 'bar'
	model.save()
	delete model.foo
	model.bar = 'foo'
	model.save()