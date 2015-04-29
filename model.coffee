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
			_.extend @, selector: doc

		options = _.extend {}, @constructor.defaults, options
		@[Model.options.optionsKey] = options
		@[Model.options.cacheKey] = {}

	selector: -> _id: @_id

	update: (modifier, cont) ->
		if @constructor.collection not instanceof Mongo.Collection
			throw new Meteor.Error Model.errors.noCollection

		afterUpdate = =>
			


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
			
			for key in ownKeys
				if @[key]?.toString?() isnt cache[key]?.toString?()
					updateModifier.$set ?= {}
					updateModifier.$set[key] = @[key]

			cacheKeys = _.keys cache
			deletedKeys = _.difference cacheKeys, ownKeys

			updateModifier.$unset = {} if deletedKeys.length 
			for key in deletedKeys
				updateModifier.$unset[key] = ''

			@update updateModifier, cont

		else
			if Model.options.assignIds
				@_id = @constructor.collection._makeNewId?()
			
			# insert
			insertDoc = _.pick @, ownKeys

			afterInsert = (newid) =>
				@[Model.options.cacheKey] = _.extend {}, insertDoc, _id: newid

				if @constructor isnt Change and options?.trackChanges
					Change.fromInsert @
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
				
				



				




