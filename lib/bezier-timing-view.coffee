{$, View, EditorView} = require 'atom'

module.exports =
class BezierTimingView extends View
  @content: ->
    @div class: 'bezier-timing-preview', =>
      @div class: 'bezier-timing-ramp', =>
        @div outlet: 'dummy', class: 'bezier-timing-dummy'

      # @subview 'durationEditor', new EditorView(mini: true)

  duration: 500
  # initialize: ->
  #   @durationEditor.setText('500')

  setSpline: (@spline...) -> @updateTiming()
  setDuration: (@duration) -> @updateTiming()

  updateTiming: ->
    @dummy.attr 'style', ''
    setTimeout =>
      @dummy.attr 'style', "-webkit-animation: preview #{@duration / 1000}s cubic-bezier(#{@spline.join ', '}) infinite"
    , 100

  getModel: -> {}
