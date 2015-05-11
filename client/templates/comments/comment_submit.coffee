Template.commentSubmit.onCreated ->
  Session.set('commentSubmitErrors', {})

Template.commentSubmit.helpers
  errorMessage: -> Session.get('commentSubmitErrors')[field]
  errorClass: ->
    if ! !Session.get('commentSubmitErrors')[field] then 'has-error' else ''

Template.commentSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $body = $(e.target).find('[name=body]')
    comment = 
      body: $body.val()
      postId: template.data._id

    errors = {}
    if ! comment.body
      errors.body = "Please write some content"
      Session.set('commentSubmitErrors', errors)

    Meteor.call 'commentInsert', comment, (error, commentId) ->
      if error
        throwError error.reason
      else
        $body.val('')
      return