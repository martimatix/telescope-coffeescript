root = exports ? this

# Local (client-only) collection
root.Errors = new Mongo.Collection(null);

root.throwError = (message) ->
  Errors.insert message: message
  return