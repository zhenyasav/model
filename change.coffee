@Changes = new Mongo.Collection 'changes'

Changes.allow
	insert: -> true
	update: -> true
	remove: -> true

escape =
	'$': '\uFF04'
	'.': '\uFF0E'

escapeModifier = (sel) -> sel


class @Change extends Model
	
	@collection: Changes

	@fromUpdate: (model, modifier, extras) ->
		defauts =
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

