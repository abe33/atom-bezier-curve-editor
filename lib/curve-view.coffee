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
    statusBar = atom.workspaceView.find('.status-bar')
    @context.fillStyle = statusBar.css('background-color')
    @context.fillRect(0, 0, 200, 200)

    @context.strokeStyle = atom.workspaceView.css('color')
    @context.beginPath()
    @context.moveTo(50, 50)
    @context.lineTo(50, 150)
    @context.lineTo(150, 150)
    @context.lineTo(150, 50)
    @context.stroke()

    @context.strokeStyle = '#ff0000'
    @context.beginPath()
    @context.moveTo(50, 150)

    for n in [0..50]
      x = 50 + n * 2
      y = 150 - @spline(n / 50) * 100
      @context.lineTo(x, y)

    @context.stroke()
