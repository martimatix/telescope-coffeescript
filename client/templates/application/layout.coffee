Template.layout.onRendered () ->
  @find('#main')._uihooks =
    insertElement: (node, next) ->
      $(node).hide().insertBefore(next).fadeIn()
    removeElement: (node) ->
      $(node).fadeOut () ->
        $(@).remove()
