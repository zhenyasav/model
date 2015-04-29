@Changes = new Mongo.Collection 'changes'

Changes.allow
	insert: -> true
	update: -> true
	remove: -> true


escapeModifier = (modifier) ->

	replace =
		'$': '\uFF04'
		'.': '\uFF0E'

	rmap = (o, fn) ->
		newobj = {}
		for k, v of o
			newkey = fn k
			
			safeobj = null

			if _.isObject v
				if _.isArray v
					safeobj = v
				else if typeof v is 'function'
					safeobj = v
				else if v instanceof Date
					safeobj = v
				else
					safeobj = rmap v, fn
			else
				safeobj = v

			newobj[newkey] = safeobj
		newobj

	map = (key) -> 
		if typeof key is 'string'
			for k, v of replace
				key = key.split(k).join v
		key

	rmap modifier, map


class @Change extends Model
	
	@collection: Changes

	@fromUpdate: (model, modifier, extras) ->
		defaults =
			user: if Meteor.isClient then Meteor.userId?()

		new Change _.extend
			collectionName: model.constructor.collection._name
			records: [model._id]
			update: escapeModifier modifier
		, defaults, extras

	@fromInsert: (model, extras) ->
		defaults =
			user: if Meteor.isClient then Meteor.userId?()

		new Change _.extend
			collectionName: model.constructor.collection._name
			records: [model._id]
			insert: model[Model.options.cacheKey]
		, defaults, extras

