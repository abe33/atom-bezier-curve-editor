{View} = require 'atom'

module.exports =
class CurveView extends View
  @content: ->
    @div class: 'curve-view', =>
      @tag 'canvas', outlet: 'canvas', id: 'curve-canvas', width: '200', height: '200'

  constructor: ->
    super
    @context = @canvas[0].getContext('2d')

  setSpline: (@spline) ->

  renderSpline: ->
    @context.strokeStyle = '#ff0000'
    @context.beginPath()
    @context.moveTo(50, 150)

    for n in [0..50]
      x = 50 + n * 2
      y = 150 - @spline(n / 50) * 100
      @context.lineTo(x, y)

    @context.stroke()
    @context.closePath()
