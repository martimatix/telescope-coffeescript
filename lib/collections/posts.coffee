root = exports ? this

root.Posts = new (Mongo.Collection)('posts')

root.Posts.allow
  insert: (userId, doc) ->
  # only allow posting if you are logged in
  ! !userId