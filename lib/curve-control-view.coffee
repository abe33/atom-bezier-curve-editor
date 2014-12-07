{View, $} = require 'atom-space-pen-views'

module.exports =
class CurveControlView extends View
  @content: ->
    @div class: 'dummy'

  constructor: (@minX, @maxX, @minY, @maxY) ->
    super

  activate: ->
    @on 'mousedown', @onMouseDown
    $('body').on 'mousemove', @onMouseMove
    $('body').on 'mouseup', @onMouseUp

  deactivate: ->
    @off

  destroy: ->
    @deactivate()
    @detach()

  onMouseDown: (e) =>
    @dragging = true
    @trigger('drag:start', @getMousePosition(e))

  onMouseMove: (e) =>
    if @dragging
      @trigger('drag', @getMousePosition(e))

  onMouseUp: (e) =>
    @trigger('drag:end', @getMousePosition(e)) if @dragging
    @dragging = false

  getMousePosition: (e) ->
    x = e.pageX - @parent().offset().left
    y = e.pageY - @parent().offset().top
    difX = @maxX - @minX
    difY = @maxY - @minY

    x = Math.max(@minX, Math.min(@maxX, x))

    {
      x: (x - @minX) / difX
      y: 1 - (y - @minY) / difY
    }
