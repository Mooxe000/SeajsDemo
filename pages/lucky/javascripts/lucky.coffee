alert "这个例子不支持 Old IE" if document.attahEvent

define (require) ->
  data = require '/widgets/luckyball/javascripts/data'
  lucky = require '/widgets/luckyball/javascripts/luckyball'

  lucky.init data