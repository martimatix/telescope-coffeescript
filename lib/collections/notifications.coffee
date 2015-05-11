root = exports ? this

root.Notifications = new Mongo.Collection('Notifications')

Notifications.allow
  update: (userId, doc, fieldNames) ->
    ownsDocument(userId, doc) and fieldNames[0] == 'read'

root.createCommentNotification = (comment) ->
  post = Posts.findOne(comment.postId)
  if comment.Userid isnt post.userId
    Notifications.insert
      userId: post.userId
      postId: post._id
      commentId: comment._id
      commenterName: comment.author
      read: false
  return
