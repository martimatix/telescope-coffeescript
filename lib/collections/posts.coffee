root = exports ? this

root.Posts = new (Mongo.Collection)('posts')

Posts.allow
  update: (userId, post) -> root.ownsDocument(userId, post)
  remove: (userId, post) -> root.ownsDocument(userId, post)

Posts.deny
  update: (userId, post, fieldNames, modifier) ->
    errors = validatePost(modifier.$set)
    errors.title or errors.url

validatePost = (post) ->
  errors = {}
  if !post.title
    errors.title = "Please fill in a headline"
  if !post.url
    errors.url = "Please fill in a URL"
  return errors
  

Meteor.methods
  postInsert: (postAttributes) ->
    check Meteor.userId(), String
    check postAttributes,
      title: String
      url: String

    errors = validatePost postAttributes
    if errors.title or errors.url
      throw new Meteor.Error 'invalid-post', "You must set a title and URL for your post"

    postWithSameLink = root.Posts.findOne url: postAttributes.url
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
      commentsCount: 0
    postId = root.Posts.insert(post)
    { _id: postId }
    