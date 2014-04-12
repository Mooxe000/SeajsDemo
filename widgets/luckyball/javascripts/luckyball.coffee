define (require, exports, module) ->
  $ = require 'jquery'
  require 'jquery-easing'
  User = require '/widgets/luckyball/javascripts/user'

  HIT_SPEED = 100
  RIGIDITY = 4

  module.exports = {
    users: []
    init: (data) ->
      $('#container').css 'background', 'none'
      @data = data
      @users = data.map (name) ->
        new User name, data[name]
      @_bindUI()
    _bindUI: ->
      that = @

      # bind button
      trigger = document.querySelector '#go'
      trigger.innerHTML = trigger.getAttribute 'data-text-start'
      trigger.addEventListener 'click', go, false
      go = ->
        if trigger.getAttribute('data-action') is 'start'
          trigger.setAttribute 'data-action', 'stop'
          trigger.innerHTML = trigger.getAttribute 'data-text-stop'
          that.start()
        else
          trigger.setAttribute 'data-action', 'start'
          trigger.innerHTML = trigger.getAttribute 'data-text-start'
          that.stop()

      # bind #lucky-balls
      $('#lucky-balls').on 'click', 'li', (e) ->
        el = $ e.target
        name = el.text()

        that.addItem name
        that.hit()
        el.remove()

      # bind #balls
      $('#balls').on 'click', 'li', (e) ->
        el = $ e.target
        name = el.text()

        for user in that.users
          if user.name is name
            that.moveLucky()
            unless that.luckyUser is user
              that.setLucky user
            break

      # bind keydown
      document.addEventListener 'keydown', (ev) ->
        if ev.keyCode is 32
          go()
        else if ev.keyCode is 27
          that.moveLucky()
          $('#lucky-balls li').eq(0).click()
      ,
        false

    start: ->
      @timer && clearTimeout @timer
      @moveLucky()
      @users.forEach (user) ->
        user.start()

    stop: ->
      users = @users
      z = 0
      lucky = users[0]

      users.forEach (user) ->
        user.stop()
        if z < user.zIndex
          lucky = user
          z = user.zIndex

      lucky.bang()
      @hit()
      @luckyUser = lucky

    removeItem: (item) ->
      for user in @users
        if user is item
          @users.splice _i, 1

    addItem: (name) ->
      @users.push new User name

    moveLucky: ->
      luckyUser = @luckyUser
      if luckyUser
        luckyUser.el[0].style.cssText = ''
        luckyUser.el.prependTo '#lucky-balls'
        @removeItem luckyUser
        @luckyUser = null

    setLucky: (item) ->
      @user.forEach (user) ->
        user.stop()
      @luckyUser = item
      item.bang()
      @hit()

    hit: ->
      that = @
      hitCount = 0
      users = @users

      users.forEach (user) ->
        user.beginHit()

      for user in users
        unless _i + 1 < users.length
          break
        if isOverlap user, users[_i + 1]
          hit user, user[_i + 1]
          hitCount++

      users.forEach (user) ->
        user.hitMove()

      if hitCount > 0
        @timer = setTimeout -> that.hit()
          ,
          HIT_SPEED
  }

  # Helpers
  getOffset = (a, b) ->
    Math.sqrt (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)

  isOverlap = (a, b) ->
    getOffset a, b <= (a.width + b.width) / 2

  hit = (a, b) ->
    yOffset = b.y - a.y
    xOffset = b.x - a.x

    offset = getOffset a, b

    power = Math.ceil(((a.width + b.width) / 2 - offset) / RIGIDITY)
    yStep = if yOffset > 0 then Math.ceil(power * yOffset / offset) else Math.floor(power * yOffset / offset)
    xStep = if xOffset > 0 then Math.ceil(power * xOffset / offset) else Math.floor(power * xOffset / offset)

    if a.lucky
      b._xMove += xStep * 2
      b._yMove += yStep * 2
    else if b.lucky
      a._xMove += xStep * -2
      a._yMove += yStep * -2
    else
      a._yMove += -1 * yStep
      b._yMove += yStep
      a._xMove += -1 * xStep
      b._xMove += xStep

  module.exports
