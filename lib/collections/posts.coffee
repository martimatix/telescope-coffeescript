root = exports ? this

root.Posts = new (Mongo.Collection)('posts')

root.Posts.allow
  update: (userId, post) -> ownsDocument(userId, post)
  remove: (userId, post) -> ownsDocument(userId, post)

root.Posts.deny
  update: (userId, post, fieldNames) ->
    # may only edit the following two fields:
    _.without(fieldNames, 'url', 'title').lenght > 0

Meteor.methods postInsert: (postAttributes) ->
  check Meteor.userId(), String
  check postAttributes,
    title: String
    url: String

  postWithSameLink = Posts.findOne url: postAttributes.url
  if postWithSameLink
    return {
      postExists: true
      _id: postWithSameLink._id
    }
  user = Meteor.user()
  post = _.extend(postAttributes,
    userId: user._id
    author: user.username
    submitted: new Date)
  postId = root.Posts.insert(post)
  { _id: postId }
    