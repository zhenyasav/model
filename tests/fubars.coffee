@Fubars = new Mongo.Collection 'fubars'

Fubars.allow
	insert: -> true
	update: -> true
	remove: -> true

class @Fubar extends Model
	@collection: Fubars

if Meteor.isServer
	Meteor.startup ->
		Fubars.remove {}
		Meteor.publish null, -> Fubars.find()