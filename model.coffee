class @Model

	@collection: null

	@defaults: 
		assignIds: true
		trackChanges: true
		optionsKey: 'options'
		cacheKey: 'cache'

	defaults: ->
		created: new Date()

	constructor: (doc, options) ->
		if typeof doc is 'undefined'
			_.extend @, @defaults()
		else if typeof doc is 'string'
			@_id = doc
		else if _.isObject doc
			_.extend @, doc
		else if _.isFunction doc
			doc = undefined
			options = _.extend options, selector: doc

		options = _.extend {}, @constructor.defaults, options
		@[options.optionsKey] = options

		@[options.cacheKey] = {}

	save: (cont) ->
