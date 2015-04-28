Package.describe({
	name: 'zhenya:model',
	version: '0.0.1',
	summary: 'Logical delete, change tracking on records',
	git: 'https://github.com/zhenyasav/model',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use([
		'coffeescript', 
		'underscore',
		'mongo']);

	api.addFiles([
		'model.coffee', 
		'change.coffee'
		]);
});

Package.onTest(function(api) {
	api.use([
		'tinytest', 
		'zhenya:model', 
		'coffeescript',
		'mongo']);

	api.addFiles([
		'tests/fubars.coffee'
		]);

	api.addFiles([
		'tests/publishChanges.coffee'
		], 'server')
	
	api.addFiles([
		'tests/model.coffee'
		], 'client');
});
