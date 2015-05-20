{SpacePenDSL, EventsDelegation} = require 'atom-utils'

module.exports =
class BezierTimingElement extends HTMLElement
  SpacePenDSL.includeInto(this)

  @content: ->
    @div class: 'bezier-timing-preview', =>
      @div class: 'bezier-timing-ramp', =>
        @div outlet: 'dummy', class: 'bezier-timing-dummy'

  duration: 500

  setSpline: (@spline...) -> @updateTiming()

  setDuration: (@duration) -> @updateTiming()

  updateTiming: ->
    @dummy.style.cssText = ''
    setTimeout =>
      @dummy.style.webkitAnimation = "preview #{@duration / 1000}s cubic-bezier(#{@spline.join ', '}) alternate both infinite"
    , 100

  getModel: -> {}

module.exports = BezierTimingElement = document.registerElement 'bezier-curve-timing', prototype: BezierTimingElement.prototype
