{View} = require 'atom'

module.exports =
class CurveView extends View
  @content: ->
    @div class: 'curve-view', =>
      @tag 'canvas', id: 'curve-canvas'

  setSpline: (@spline) ->

  renderSpline: ->
