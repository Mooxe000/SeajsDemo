define (require, exports, module) ->
  $ = require 'jquery'

  CANVAS_HEIGHT = 500
  CANVAS_WIDTH = 900

  BALL_WIDTH = 60
  BALL_HEIGHT = 60
  LUCKY_BALL_WIDTH = 200
  LUCKY_BALL_HEIGHT = 200
  MAX_ZINDEX = 100

  DURATION_MIN = 100
  DURATION_MAX = 500
  ZOOM_DURATION = 500

  User = (name, options) ->
    @name = name
    @options = options || {}

    @el = null
    @width = 0
    @height = 0
    @left = 0
    @top = 0
    @x = 0
    @y = 0

    @moving = false
    @lucky = false

    @createEl()
    @move()

    @

  User::createEl = ->
    @el = $("<li>#{@name}</li>").appendTo '#balls'
    @width = @el.width()
    @height = @el.height()

  User::move = (callback) ->
    @left = r 0, CANVAS_WIDTH - @width
    @top = r 0, CANVAS_HEIGHT - @height
    @zIndex = r 0, MAX_ZINDEX
    @reflow callback

  User::reflow = (callback, direct) ->
    @x = @left + @width / 2
    @y = @top + @height / 2
    @el[0].style.zIndex = @zIndex

    if direct
      @el[0].style.left = @left
      @el[0].style.top = @top
    else
      @el.animate {
          'left': @left
          'top': @top
        }, r(DURATION_MIN, DURATION_MAX),
        'easeOutBack', callback

  User::start = ->
    @reset()
    @moving = true
    @autoMove()

  User::reset = ->
    @el.stop true, true
    @lucky = false

    @el[0].className = ''
    @el[0].style.width = "#{BALL_WIDTH}px"
    @el[0].style.height = "#{BALL_HEIGHT}px"
    @width = @el.width()
    @height = @el.height()

    @_maxTop = CANVAS_HEIGHT - @height
    @_maxLeft = CANVAS_WIDTH - @width

  User::autoMove = ->
    that = @

    if @moving
      @move ->
        that.autoMove()

  User::stop = ->
    @el.stop true, true
    @moving = false

  User::bang = ->
    @lucky = true
    @el[0].className = 'selected'
    @width = LUCKY_BALL_WIDTH
    @height = LUCKY_BALL_HEIGHT
    @left = (CANVAS_WIDTH - @width) / 2
    @top = (CANVAS_HEIGHT - @height) / 2

    @el.animate {
      'left': @left
      'top': @top
      'width': @width
      'height': @height
    }, ZOOM_DURATION

  User::beginHit = ->
    @_xMove = 0
    @_yMove = 0

  User::hitMove = ->
    @left += @_xMove
    @top += @_yMove

    @top = if @top < 0 then 0 else if @top > @_maxTop then @_maxTop else @top
    @left = if @left < 0 then 0 else if @left > @_maxLeft then @_maxLeft else @left

    @reflow null, false

  # Helpers
  r = (from, to) ->
    from = from || 0
    to = to || 1
    Math.floor Math.random() * (to - from + 1) + from

  module.exports = User
