class @Model

	@collection: null

	@errors:
		noCollection: 'Model.collection must be a collection object'

	@options: 
		optionsKey: '_options'
		cacheKey: '_cache'
		assignIds: true

	@defaults:
		trackChanges: true

	defaults: ->
		created: new Date()

	constructor: (doc, options) ->
		if typeof doc is 'undefined'
			_.extend @, @defaults()
		else if typeof doc is 'string'
			@_id = doc
		else if _.isObject doc
			if doc?._id
				_.extend @, doc
			else
				_.extend @, @defaults(), doc
		else if _.isFunction doc
			doc = undefined
			options = _.extend options, selector: doc

		options = _.extend {}, @constructor.defaults, options
		@[Model.options.optionsKey] = options
		@[Model.options.cacheKey] = {}

	update: (modifier, cont) ->

	save: (cont) ->
		if @constructor.collection not instanceof Mongo.Collection
			throw new Meteor.Error Model.errors.noCollection 

		cache = @[Model.options.cacheKey] ?= {}
		options = @[Model.options.optionsKey]
		ownKeys = _.difference _.keys(@), [
			Model.options.cacheKey
			Model.options.optionsKey
		]

		if @_id
			# update
			updateModifier = {}
			
			@update updateModifier, cont

		else
			if Model.options.assignIds
				@_id = @constructor.collection._makeNewId?()
			
			# insert
			insertDoc = _.pick @, ownKeys

			afterInsert = (newid) =>
				@[Model.options.cacheKey] = _.extend {}, insertDoc, _id: newid

				if @constructor isnt Change and options?.trackChanges
					Change.modelInserted @
					.save()

				@_id = newid

			if typeof cont is 'function'
				# async
				@constructor.collection.insert insertDoc, (err, newid) =>
					return cont? err if err?
					
					afterInsert newid

					cont? null, id
			else
				# sync
				afterInsert @constructor.collection.insert insertDoc
				
				



				




