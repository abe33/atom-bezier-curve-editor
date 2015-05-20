{CompositeDisposable, Emitter} = require 'atom'
{EventsDelegation} = require 'atom-utils'

module.exports =
class CurveControlElement extends HTMLElement
  EventsDelegation.includeInto(this)

  createdCallback: ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

  initialize: ({@minX, @maxX, @minY, @maxY}) ->

  onDidStartDrag: (callback) ->
    @emitter.on 'did-start-drag', callback

  onDidDrag: (callback) ->
    @emitter.on 'did-drag', callback

  onDidEndDrag: (callback) ->
    @emitter.on 'did-end-drag', callback

  activate: ->
    @subscriptions.add @subscribeTo this, 'mousedown': (e) =>
      @onMouseDown(e)

    @subscriptions.add @subscribeTo document.body,
      'mousemove': (e) => @onMouseMove(e)
      'mouseup': (e) => @onMouseUp(e)

  deactivate: ->
    @subscriptions.dispose()

  destroy: ->
    @deactivate()
    @detach()

  onMouseDown: (e) ->
    @dragging = true
    @emitter.emit('did-start-drag', @getMousePosition(e))

  onMouseMove: (e) ->
    if @dragging
      @emitter.emit('did-drag', @getMousePosition(e))

  onMouseUp: (e) ->
    @emitter.emit('did-end-drag', @getMousePosition(e)) if @dragging
    @dragging = false

  getMousePosition: (e) ->
    offset = @parentNode.getBoundingClientRect()
    x = e.pageX - offset.left
    y = e.pageY - offset.top
    difX = @maxX - @minX
    difY = @maxY - @minY

    x = Math.max(@minX, Math.min(@maxX, x))

    {
      x: (x - @minX) / difX
      y: 1 - (y - @minY) / difY
    }

module.exports = CurveControlElement = document.registerElement 'bezier-curve-control', prototype: CurveControlElement.prototype
