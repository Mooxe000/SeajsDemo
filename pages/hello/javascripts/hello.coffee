define (require) ->
  Spining = require '/widgets/spinning/javascripts/spinning'
  s = new Spining '#container'
  s.render()
