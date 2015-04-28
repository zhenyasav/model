Meteor.publish null, -> Changes.find()

Meteor.startup ->
	Changes.remove {}
