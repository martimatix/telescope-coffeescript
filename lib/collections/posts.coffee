root = exports ? this

root.Posts = new (Mongo.Collection)('posts')

root.Posts.allow
  # only allow posting if you are logged in
  insert: (userId, doc) -> return !! userId
    