root = exports ? this

Template.postEdit.onCreated -> Session.set('postEditErrors', {})

Template.postEdit.helpers
  errorMessage: (field) -> Session.get('postEditErrors')[field]
  errorClass: (field) -> !!Session.get('postEditErrors')[field] ? 'has-error' : ''

Template.postEdit.events
  'submit form': (e) ->
    e.preventDefault()

    currentPostId = @_id

    postProperties =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    errorMessage = validatePost postProperties
    if errors.title or errors.url
      return Session.set 'postEditErrors', errors

    Posts.update currentPostId, {$set: postProperties}, (error) ->
      if error
        # display the error to the user
        throwError error.reason
      else
        Router.go 'postPage', {_id: currentPostId}
    
  'click .delete': (e) ->
    e.preventDefault()

    if confirm("Delete this post?")
      currentPostId = @._id
      Posts.remove(currentPostId)
      Router.go('postsList')



