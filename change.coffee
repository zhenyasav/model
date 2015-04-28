@Changes = new Mongo.Collection 'changes'

Changes.allow
	insert: -> true
	update: -> true
	remove: -> true

escape =
	'$': '\uFF04'
	'.': '\uFF0E'

class @Change extends Model
	
	@collection: Changes

	@modelInserted: (model, extras) ->
		defaults = 
			user: if Meteor.isClient then Meteor.userId?()

		new Change _.extend
			collectionName: model.constructor.collection._name
			records: [model._id]
			insert: model[Model.options.cacheKey]
		, defaults, extras