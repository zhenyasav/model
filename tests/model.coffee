### TINYTEST
test.isFalse(v, msg)
test.isTrue(v, msg)
test.equal(actual, expected, message, not)
test.length(obj, len)
test.include(s, v)
test.isNaN(v, msg)
test.isUndefined(v, msg)
test.isNotNull
test.isNull
test.throws(func)
test.instanceOf(obj, klass)
test.notEqual(actual, expected, message)
test.runId()
test.exception(exception)
test.expect_fail()
test.ok(doc)
test.fail(doc)
###

Tinytest.add 'model - save new', (test) ->
	model = new Fubar()
	try
		model.save()
	catch err
		test.fail err

	test.isTrue typeof model._id is 'string' and model._id, '_id is a nonempty string'

