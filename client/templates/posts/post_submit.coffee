root = exports ? this

Template.postSubmit.events
  'submit form': (e) ->
    e.preventDefault()

    post = 
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    post._id = root.Posts.insert(post)
    Router.go 'postPage', post
