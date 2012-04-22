#/**********************************************************************
#TERMS OF USE - EASING EQUATIONS
#Open source under the BSD License.
#Copyright (c) 2001 Robert Penner
#JavaScript version copyright (C) 2006 by Philippe Maegerman
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are
#met:
#
#   * Redistributions of source code must retain the above copyright
#notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above
#copyright notice, this list of conditions and the following disclaimer
#in the documentation and/or other materials provided with the
#distribution.
#   * Neither the name of the author nor the names of contributors may
#be used to endorse or promote products derived from this software
#without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#*****************************************/

#Automatically converted into coffeescript

Delegate = ->
Delegate.create = (o, f) ->
    a = new Array()
    l = arguments.length
    i = 2

    while i < l
      a[i - 2] = arguments[i]
      i++
    ->
      aP = [].concat(arguments, a)
      f.apply o, aP

Tween = (obj, prop, func, begin, finish, duration, suffixe) ->
    @init obj, prop, func, begin, finish, duration, suffixe

t = Tween::
t.obj = new Object()
t.prop = ""
t.func = (t, b, c, d) ->
    c * t / d + b

t.begin = 0
t.change = 0
t.prevTime = 0
t.prevPos = 0
t.looping = false
t._duration = 0
t._time = 0
t._pos = 0
t._position = 0
t._startTime = 0
t._finish = 0
t.name = ""
t.suffixe = ""
t._listeners = new Array()
t.setTime = (t) ->
    @prevTime = @_time
    if t > @getDuration()
      if @looping
        @rewind t - @_duration
        @update()
        @broadcastMessage "onMotionLooped",
          target: this
          type: "onMotionLooped"
      else
        @_time = @_duration
        @update()
        @stop()
        @broadcastMessage "onMotionFinished",
          target: this
          type: "onMotionFinished"
    else if t < 0
      @rewind()
      @update()
    else
      @_time = t
      @update()

t.getTime = ->
    @_time

t.setDuration = (d) ->
    @_duration = (if (not d? or d <= 0) then 100000 else d)

t.getDuration = ->
    @_duration

t.setPosition = (p) ->
    @prevPos = @_pos
    a = (if @suffixe isnt "" then @suffixe else "")
    @obj[@prop] = Math.round(p) + a
    @_pos = p
    @broadcastMessage "onMotionChanged",
      target: this
      type: "onMotionChanged"

t.getPosition = (t) ->
    t = @_time  if t is `undefined`
    @func t, @begin, @change, @_duration

t.setFinish = (f) ->
    @change = f - @begin

t.geFinish = ->
    @begin + @change

t.init = (obj, prop, func, begin, finish, duration, suffixe) ->
    return  unless arguments.length
    @_listeners = new Array()
    @addListener this
    @suffixe = suffixe  if suffixe
    @obj = obj
    @prop = prop
    @begin = begin
    @_pos = begin
    @setDuration duration
    @func = func  if func? and func isnt ""
    @setFinish finish

t.start = ->
    @rewind()
    @startEnterFrame()
    @broadcastMessage "onMotionStarted",
      target: this
      type: "onMotionStarted"

t.rewind = (t) ->
    @stop()
    @_time = (if (t is `undefined`) then 0 else t)
    @fixTime()
    @update()

t.fforward = ->
    @_time = @_duration
    @fixTime()
    @update()

t.update = ->
    @setPosition @getPosition(@_time)

t.startEnterFrame = ->
    @stopEnterFrame()
    @isPlaying = true
    @onEnterFrame()

t.onEnterFrame = ->
    if @isPlaying
      @nextFrame()
      setTimeout Delegate.create(this, @onEnterFrame), 0

t.nextFrame = ->
    @setTime (@getTimer() - @_startTime) / 1000

t.stop = ->
    @stopEnterFrame()
    @broadcastMessage "onMotionStopped",
      target: this
      type: "onMotionStopped"

t.stopEnterFrame = ->
    @isPlaying = false

t.continueTo = (finish, duration) ->
    @begin = @_pos
    @setFinish finish
    @setDuration duration  unless @_duration is `undefined`
    @start()

t.resume = ->
    @fixTime()
    @startEnterFrame()
    @broadcastMessage "onMotionResumed",
      target: this
      type: "onMotionResumed"

t.yoyo = ->
    @continueTo @begin, @_time

t.addListener = (o) ->
    @removeListener o
    @_listeners.push o

t.removeListener = (o) ->
    a = @_listeners
    i = a.length
    while i--
      if a[i] is o
        a.splice i, 1
        return true
    false

t.broadcastMessage = ->
    arr = new Array()
    i = 0

    while i < arguments.length
      arr.push arguments[i]
      i++
    e = arr.shift()
    a = @_listeners
    l = a.length
    i = 0

    while i < l
      a[i][e].apply a[i], arr  if a[i][e]
      i++

t.fixTime = ->
    @_startTime = @getTimer() - @_time * 1000

t.getTimer = ->
    new Date().getTime() - @_time

Tween.backEaseIn = (t, b, c, d, a, p) ->
    s = 1.70158  if s is `undefined`
    c * (t /= d) * t * ((s + 1) * t - s) + b

Tween.backEaseOut = (t, b, c, d, a, p) ->
    s = 1.70158  if s is `undefined`
    c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b

Tween.backEaseInOut = (t, b, c, d, a, p) ->
    s = 1.70158  if s is `undefined`
    return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b  if (t /= d / 2) < 1
    c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b

Tween.elasticEaseIn = (t, b, c, d, a, p) ->
    return b  if t is 0
    return b + c  if (t /= d) is 1
    p = d * .3  unless p
    if not a or a < Math.abs(c)
      a = c
      s = p / 4
    else
      s = p / (2 * Math.PI) * Math.asin(c / a)
    -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b

Tween.elasticEaseOut = (t, b, c, d, a, p) ->
    return b  if t is 0
    return b + c  if (t /= d) is 1
    p = d * .3  unless p
    if not a or a < Math.abs(c)
      a = c
      s = p / 4
    else
      s = p / (2 * Math.PI) * Math.asin(c / a)
    a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b

Tween.elasticEaseInOut = (t, b, c, d, a, p) ->
    return b  if t is 0
    return b + c  if (t /= d / 2) is 2
    p = d * (.3 * 1.5)  unless p
    if not a or a < Math.abs(c)
      a = c
      s = p / 4
    else
      s = p / (2 * Math.PI) * Math.asin(c / a)
    return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b  if t < 1
    a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b

Tween.bounceEaseOut = (t, b, c, d) ->
    if (t /= d) < (1 / 2.75)
      c * (7.5625 * t * t) + b
    else if t < (2 / 2.75)
      c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b
    else if t < (2.5 / 2.75)
      c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b
    else
      c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b

Tween.bounceEaseIn = (t, b, c, d) ->
    c - Tween.bounceEaseOut(d - t, 0, c, d) + b

Tween.bounceEaseInOut = (t, b, c, d) ->
    if t < d / 2
      Tween.bounceEaseIn(t * 2, 0, c, d) * .5 + b
    else
      Tween.bounceEaseOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b

Tween.strongEaseInOut = (t, b, c, d) ->
    c * (t /= d) * t * t * t * t + b

Tween.regularEaseIn = (t, b, c, d) ->
    c * (t /= d) * t + b

Tween.regularEaseOut = (t, b, c, d) ->
    -c * (t /= d) * (t - 2) + b

Tween.regularEaseInOut = (t, b, c, d) ->
    return c / 2 * t * t + b  if (t /= d / 2) < 1
    -c / 2 * ((--t) * (t - 2) - 1) + b

Tween.strongEaseIn = (t, b, c, d) ->
    c * (t /= d) * t * t * t * t + b

Tween.strongEaseOut = (t, b, c, d) ->
    c * ((t = t / d - 1) * t * t * t * t + 1) + b

Tween.strongEaseInOut = (t, b, c, d) ->
    return c / 2 * t * t * t * t * t + b  if (t /= d / 2) < 1
    c / 2 * ((t -= 2) * t * t * t * t + 2) + b
