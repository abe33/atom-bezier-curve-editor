{View} = require 'atom'

{UnitBezier} = require './bezier-functions'

module.exports =
class CurveView extends View
  @content: ->
    @div class: 'curve-view', =>
      @tag 'canvas', outlet: 'canvas', id: 'curve-canvas', width: '200', height: '200'
      @div class: 'dummy', id: 'point1', outlet: 'dummy1'
      @div class: 'dummy', id: 'point2', outlet: 'dummy2'

  constructor: ->
    super
    @context = @canvas[0].getContext('2d')

  setSpline: (@x1, @y1, @x2, @y2) ->
    @spline = new UnitBezier @x1, @y1, @x2, @y2

  cleanCanvas: ->
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

  updateDummies: ->
    @dummy1.css
      top: 150 - @y1 * 100
      left: 50 + @x1 * 100

    @dummy2.css
      top: 150 - @y2 * 100
      left: 50 + @x2 * 100

  renderControls: ->
    statusBar = atom.workspaceView.find('.status-bar')
    @context.strokeStyle = statusBar.css('color')
    @context.beginPath()
    @context.moveTo(50, 150)
    @context.lineTo(50 + @x1 * 100, 150 - @y1 * 100)
    @context.stroke()

    @context.beginPath()
    @context.moveTo(150, 50)
    @context.lineTo(50 + @x2 * 100, 150 - @y2 * 100)
    @context.stroke()

  renderSpline: ->
    @cleanCanvas()
    @updateDummies()
    @renderControls()

    @context.strokeStyle = '#ff0000'
    @context.beginPath()
    @context.moveTo(50, 150)

    for n in [0..50]
      x = 50 + n * 2
      y = 150 - @spline.solve(n / 50, @spline.epsilon) * 100
      @context.lineTo(x, y)

    @context.stroke()
