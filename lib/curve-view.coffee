{$, View} = require 'atom-space-pen-views'

{UnitBezier} = require './bezier-functions'
CurveControlView = require './curve-control-view'

module.exports =
class CurveView extends View
  @canvasWidth: 200
  @canvasHeight: 200
  @canvasPadding: 50

  @content: ->
    @div class: 'curve-view', =>
      @tag 'canvas', {
        outlet: 'canvas'
        id: 'curve-canvas'
        width: @canvasWidth
        height: @canvasHeight
      }

      minX = @canvasPadding
      maxX = @canvasWidth - @canvasPadding
      minY = @canvasPadding
      maxY = @canvasHeight - @canvasPadding

      @subview 'dummy1', new CurveControlView minX, maxX, minY, maxY
      @subview 'dummy2', new CurveControlView minX, maxX, minY, maxY

  initialize: ->
    @dummy1.on 'drag', @control1Changed
    @dummy2.on 'drag', @control2Changed

    @dummy1.on 'drag:end', => @trigger 'spline:changed'
    @dummy2.on 'drag:end', => @trigger 'spline:changed'

  constructor: ->
    super
    @context = @canvas[0].getContext('2d')
    @canvasWidth = @constructor.canvasWidth
    @canvasHeight = @constructor.canvasHeight
    @canvasPadding = @constructor.canvasPadding
    @canvasWidthMinusPadding = @canvasWidth - @canvasPadding
    @canvasHeightMinusPadding = @canvasHeight - @canvasPadding
    @curveSpaceWidth = @canvasWidth - @canvasPadding * 2
    @curveSpaceHeight = @canvasHeight - @canvasPadding * 2

  getSpline: -> [@x1, @y1, @x2, @y2]

  setSpline: (@x1, @y1, @x2, @y2) ->

  cleanCanvas: ->
    statusBar = $('.status-bar')
    @context.fillStyle = statusBar.css('background-color')
    console.log statusBar.css('background-color')
    @context.fillRect(0, 0, @canvasWidth, @canvasWidth)

    @context.strokeStyle = $('atom-workspace').css('color')
    @context.beginPath()
    @context.moveTo(@canvasPadding, @canvasPadding)
    @context.lineTo(@canvasPadding, @canvasHeightMinusPadding)
    @context.lineTo(@canvasWidthMinusPadding, @canvasHeightMinusPadding)
    @context.lineTo(@canvasWidthMinusPadding, @canvasPadding)
    @context.lineTo(@canvasPadding, @canvasPadding)
    @context.stroke()

  updateDummies: ->
    @dummy1.css
      top: @canvasHeightMinusPadding - @y1 * @curveSpaceHeight
      left: @canvasPadding + @x1 * @curveSpaceWidth

    @dummy2.css
      top: @canvasHeightMinusPadding - @y2 * @curveSpaceHeight
      left: @canvasPadding + @x2 * @curveSpaceWidth

  renderControls: ->
    statusBar = $('.status-bar')
    @context.strokeStyle = statusBar.css('color')

    @context.beginPath()
    @context.moveTo(@canvasPadding, @canvasHeightMinusPadding)
    @context.lineTo(
      @canvasPadding + @x1 * @curveSpaceWidth,
      @canvasHeightMinusPadding - @y1 * @curveSpaceHeight
    )
    @context.stroke()

    @context.beginPath()
    @context.moveTo(@canvasWidthMinusPadding, @canvasPadding)
    @context.lineTo(
      @canvasPadding + @x2 * @curveSpaceWidth,
      @canvasHeightMinusPadding - @y2 * @curveSpaceHeight
    )
    @context.stroke()

  renderSpline: ->
    @cleanCanvas()
    @updateDummies()
    @renderControls()

    @context.strokeStyle = '#ff0000'
    @context.beginPath()
    @context.moveTo(@canvasPadding, @canvasHeightMinusPadding)

    spline = new UnitBezier @x1, @y1, @x2, @y2

    for n in [0..50]
      r = n / 50
      x = @canvasPadding + r * @curveSpaceWidth
      curveY = spline.solve(r, spline.epsilon)
      y = @canvasHeightMinusPadding - curveY * @curveSpaceHeight
      @context.lineTo(x, y)

    @context.stroke()

  control1Changed: (e, {x, y}) =>
    @x1 = x
    @y1 = y
    @renderSpline()

  control2Changed: (e, {x, y}) =>
    @x2 = x
    @y2 = y
    @renderSpline()
