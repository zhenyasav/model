# Model

A package for Meteor to provide common behaviours and business logic encapsulation on database records.

#### Business logic encapsulation
Database objects like to have an API, for example to expand a relationship. `Car.getWheels()` might return a cursor to some wheels. Another example would be models having a `created:` timestamp just by saying something like `new Car()`.

#### Validation
DSL for specifying shape and value rules on data

#### Logical delete
A common behaviour for all models where `Model.remove()` actually calls `Model.set({deleted: new Date()})`. This makes it easy to know if and when an object was deleted.

#### Change tracking
Every model write is duplicated in another collection describing who did the write, when, and what exactly changed.

#### Undo/Redo
Having automatic change tracking means it's easy to revert writes.

#### Easy save
Sometimes it's convenient to work with object keys in memory and call a save method later. `car.name = "foo"; car.save()`

#### UI Patterns
Make it easier to build graceful model-editing UI, for example for admin purposes.