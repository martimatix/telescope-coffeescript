root = exports ? this

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('notifications')]

root.PostsListController = RouteController.extend(
  template: 'postsList'
  increment: 5
  postsLimit: ->
    parseInt(@params.postsLimit) or @increment
  findOptions: ->
    {
      sort: submitted: -1
      limit: @postsLimit()
    }
  subscriptions: ->
    @postsSub = Meteor.subscribe('posts', @findOptions())
  waitOn: ->
    Meteor.subscribe 'posts', @findOptions()
  posts: ->
    Posts.find({}, @findOptions())
  data: ->
    hasMore = @posts().count() == @postsLimit()
    nextPath = @route.path({ postsLimit: @postsLimit() + @increment })

    {
      posts: @posts()
      ready: @postsSub.ready
      nextPath: if hasMore then nextPath else null
    }
)

Router.route '/posts/:_id',
  name: 'postPage'
  waitOn: ->
    Meteor.subscribe('comments', @params._id)
  data: -> Posts.findOne(@params._id)

Router.route '/posts/:_id/edit',
  name: 'postEdit'
  data: -> Posts.findOne(@params._id)

Router.route '/submit', name: 'postSubmit'

Router.route '/:postsLimit?',
  name: 'postsList'

requireLogin = ->
  if !Meteor.user()
    if Meteor.loggingIn()
      @render(@loadingTemplate)
    else
      @render('accessDenied')
  else
    @next()

Router.onBeforeAction 'dataNotFound', only: 'postPage'
Router.onBeforeAction requireLogin, only: 'postSubmit'
