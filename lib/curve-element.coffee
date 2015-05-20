{CompositeDisposable, Emitter} = require 'atom'
{SpacePenDSL, AncestorsMethods} = require 'atom-utils'
{UnitBezier} = require './bezier-functions'
CurveControlElement = require './curve-control-element'

module.exports =
class CurveElement extends HTMLElement
  SpacePenDSL.includeInto(this)

  canvasWidth = 200
  canvasHeight = 200
  canvasPadding = 50

  @content: ->
    @div class: 'curve-view', =>
      @tag 'canvas', {
        outlet: 'canvas'
        id: 'curve-canvas'
        width: canvasWidth
        height: canvasHeight
      }

      @tag 'bezier-curve-control', outlet: 'dummy1'
      @tag 'bezier-curve-control', outlet: 'dummy2'

  createdCallback: ->
    @subscriptions = new CompositeDisposable
    @emitter = new Emitter

    @context = @canvas.getContext('2d')
    @canvasWidth = canvasWidth
    @canvasHeight = canvasHeight
    @canvasPadding = canvasPadding
    @canvasWidthMinusPadding = @canvasWidth - @canvasPadding
    @canvasHeightMinusPadding = @canvasHeight - @canvasPadding
    @curveSpaceWidth = @canvasWidth - @canvasPadding * 2
    @curveSpaceHeight = @canvasHeight - @canvasPadding * 2
    @cleanCanvas()

    minX = @canvasPadding
    maxX = @canvasWidth - @canvasPadding
    minY = @canvasPadding
    maxY = @canvasHeight - @canvasPadding

    @dummy1.initialize {minX, maxX, minY, maxY}
    @dummy2.initialize {minX, maxX, minY, maxY}

    @subscriptions.add @dummy1.onDidDrag (e) => @control1Changed(e)
    @subscriptions.add @dummy2.onDidDrag (e) => @control2Changed(e)

    @dummy1.onDidEndDrag => @emitter.emit 'did-change-spline'
    @dummy2.onDidEndDrag => @emitter.emit 'did-change-spline'

  onDidChangeSpline: (callback) ->
    @emitter.on 'did-change-spline', callback

  getSpline: -> [@x1, @y1, @x2, @y2]

  setSpline: (@x1, @y1, @x2, @y2) ->

  cleanCanvas: ->
    styles = getComputedStyle(AncestorsMethods.parents(this, 'bezier-curve-editor')[0])
    @context.fillStyle = styles.backgroundColor
    @context.fillRect(0, 0, @canvasWidth, @canvasWidth)

    @context.strokeStyle = styles.color
    @context.beginPath()
    @context.moveTo(@canvasPadding, @canvasPadding)
    @context.lineTo(@canvasPadding, @canvasHeightMinusPadding)
    @context.lineTo(@canvasWidthMinusPadding, @canvasHeightMinusPadding)
    @context.lineTo(@canvasWidthMinusPadding, @canvasPadding)
    @context.lineTo(@canvasPadding, @canvasPadding)
    @context.stroke()

  updateDummies: ->
    @dummy1.style.top = (@canvasHeightMinusPadding - @y1 * @curveSpaceHeight) + 'px'
    @dummy1.style.left = (@canvasPadding + @x1 * @curveSpaceWidth) + 'px'

    @dummy2.style.top = (@canvasHeightMinusPadding - @y2 * @curveSpaceHeight) + 'px'
    @dummy2.style.left = (@canvasPadding + @x2 * @curveSpaceWidth) + 'px'

  renderControls: ->
    panel = document.querySelector('atom-panel')
    return unless panel?

    @context.strokeStyle = getComputedStyle(panel).color

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
    requestAnimationFrame =>
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

  control1Changed: ({x, y}) =>
    @x1 = x
    @y1 = y
    @renderSpline()

  control2Changed: ({x, y}) =>
    @x2 = x
    @y2 = y
    @renderSpline()

module.exports = CurveElement = document.registerElement 'bezier-curve', prototype: CurveElement.prototype
