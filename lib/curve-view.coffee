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
