Template.notifications.helpers
  notifications: ->
    Notifications.find
      userId: Meteor.userId()
      read: false
  notificationCount: ->
    Notificatios.find(
      userId: Meteor.userId()
      read: false).count()

Template.notificationItem.helpers
  notificationPostPath: ->
    Router.routes.postPage.path( _id: @postId )

Template.notificationItem.events
  'click a': -> Notificatios.update( @_id, {$set: {read: true}})
  return