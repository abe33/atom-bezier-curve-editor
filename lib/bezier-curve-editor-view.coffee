{$, View} = require 'atom'
Delegator = require 'delegato'
CurveView = require './curve-view'

module.exports =
class BezierCurveEditorView extends View
  Delegator.includeInto(this)

  @content: ->
    @div class: 'bezier-curve-editor', =>
      @subview 'curveView', new CurveView()

  @delegatesMethods 'setSpline', 'renderSpline', toProperty: 'curveView'

  initialize: (serializeState) ->
    atom.workspaceView.command "bezier-curve-editor:toggle", => @toggle()

  open: ->
    @attach()

    @subscribeToOutsideEvent()

  subscribeToOutsideEvent: ->
    $body = @parents('body')

    @subscribe $body, 'mousedown', @closeIfClickedOutside

  closeIfClickedOutside: (e) =>
    $target = $(e.target)

    @close() if $target.parents('.bezier-curve-editor').length is 0

  attach: -> atom.workspaceView.find('.vertical').append(this)
  close: -> @detach()
  destroy: -> @close()
