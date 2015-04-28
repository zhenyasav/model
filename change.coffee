@Changes = new Mongo.Collection 'changes'

class @Change extends Model
	@collection: @Changes