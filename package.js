Package.describe({
  name: 'zhenya:model',
  version: '0.0.1',
  summary: 'Logical delete, change tracking on records',
  git: 'https://github.com/zhenyasav/model',
  documentation: 'README.md'
});

Package.onUse(function(api) {
 
  api.versionsFrom('1.0');

  api.use(['coffeescript']);

  api.addFiles(['model.coffee']);

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('zhenya:model');
});
