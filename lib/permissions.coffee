root = exports ? this

# check that the userId specified owns the document
root.ownsDocument = (userId, doc) ->
  doc and doc.userId == userId