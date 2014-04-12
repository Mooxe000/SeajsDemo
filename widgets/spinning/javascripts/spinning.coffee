define (require, exports, module) ->
  $ = require 'jquery'

  Spinning = (container) ->
    @container = $ container
    @icons = @container.children()
    @spinnings = []
    @

  Spinning::render = ->
    @_init()
    @container.css 'background', 'none'
    @icons.show()
    @_spin()
    @

  Spinning::_init = ->
    spinnings = @spinnings

    $(@icons).each (n) ->
      startDeg = random 360
      node = $ @
      timer = null

      node.css {
        top: random 40
        left: n * 50 + random 10
        zIndex: 1000
      }

      hoverOn = ->
        node
          .fadeTo(250, 1)
          .css('zIndex', 1001)
          .css('transform', 'rotate(0deg)')
      hoverOff = ->
        node
          .fadeTo(250, .6)
          .css('zIndex', 1001)
        timer && clearTimeout timer
        timer = setTimeout spin, Math.ceil random 10000

      node.hover hoverOn, hoverOff

      spin = ->
        node.css 'transform', "rotate(#{startDeg}deg)"

      spinnings[n] = spin

    @spinnings = spinnings
    @

  Spinning::_spin = ->

    $(@spinnings).each (i, fn) ->
      setTimeout fn, Math.ceil random 3000

    @

  random = (x) ->
    Math.random() * x

  module.exports = Spinning
