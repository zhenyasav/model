class @Model

	@collection: null

	@errors:
		noCollection: (op) -> op + ' failed: Model.collection must be a collection object'
		noModifier: (op) -> op + ' failed: Model.update expects a modifier object'
		invalidSelector: (op) -> op + ' failed: Model selector is invalid'

	@options: 
		optionsKey: '_options'
		cacheKey: '_cache'
		assignIds: false
		autoFetch: false

	@defaults:
		trackChanges: false

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
			options.updateMulti = true

		options = _.extend {}, @constructor.defaults, options
		@[Model.options.optionsKey] = options
		@[Model.options.cacheKey] = {}

	selector: -> _id: @_id

	update: (modifier, options, cont) ->
		if @constructor.collection not instanceof Mongo.Collection
			throw new Meteor.Error Model.errors.noCollection 'update'

		if not _.isObject modifier 
			throw new Meteor.Error Model.errors.noModifier 'update'

		if typeof options is 'function'
			cont = options
			options = null

		options = _.extend {}, @[Model.options.optionsKey], options

		selector = @selector()

		if not selector? or not _.isObject(selector) or _.isEmpty selector
			throw new Meteor.Error Model.errors.invalidSelector 'update'

		afterUpdate = (affected) =>
			if affected
				if @ not instanceof Change and options?.trackChanges
					Change.fromUpdate @, modifier
					.save()
			affected

		if typeof cont is 'function' or Meteor.isClient
			@constructor.collection.update selector, modifier, (err, res) =>
				return cont? err if err?
				afterUpdate res
				cont? null, res
		else
			afterUpdate @constructor.collection.update selector, modifier

	save: (cont) ->
		if @constructor.collection not instanceof Mongo.Collection
			throw new Meteor.Error Model.errors.noCollection 'save'

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

			@update updateModifier, autoFetch: false, cont

		else
			if Model.options.assignIds
				@_id = @constructor.collection._makeNewId?()
			
			# insert
			insertDoc = _.pick @, ownKeys

			afterInsert = (newid) =>
				@[Model.options.cacheKey] = _.extend {}, insertDoc, _id: newid

				if @ not instanceof Change and options?.trackChanges
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
				
				



				




