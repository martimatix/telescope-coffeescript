Template.errors.helpers
  errors: -> Errors.find()

Template.error.onRendered ->
  error = @data
  removeError = -> Errors.remove error._id
  Meteor.setTimeout removeError, 3000