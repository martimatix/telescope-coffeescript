root = exports ? this

Meteor.publish 'posts', ->
  root.Posts.find()