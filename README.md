# Model

A package for Meteor to provide business logic encapsulation on database records.

Objective | Description
-------------- | ---
Business logic encapsulation | Database objects like to have an API, for example to expand a relationship. `Car.getWheels()` should return a cursor to some wheels. Another example would be models having a `created:` timestamp just by saying something like `new Car()`.
Easy save | Sometimes it's convenient to work with object keys in memory and call a save method later. `car.name = "foo"; car.save()`
Logical delete | A common behaviour for all models where `Model.remove()` actually calls `Model.set({deleted: new Date()})`. This makes it easy to know if and when an object was deleted.
Change tracking | Every model write is duplicated in another collection describing who did the write, when, and what exactly changed.
Undo/Redo | Having automatic change tracking means it's easy to revert writes.
Read/Write transforms | Sometimes you want to work with 3rd party objects where it's easier to treat a subkey like the entire model itself to avoid colliding with other logic. For example, you might want to work with `Meteor.users.findOne(id).profile.firstName` in simpler terms like `new User(id).firstName` but still retain the database structure `User.profile.firstName` when the model is saved.
Validation | DSL for specifying the shape and value rules on models
UI Bindings | Make it easier to build model-editing UI