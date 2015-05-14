Template.registerHelper 'pluralize', (n, thing) ->
  # fairly stupid pluralizer
  if n is 1
    return "1 #{thing}"
  else
    return "#{n} #{thing}s"