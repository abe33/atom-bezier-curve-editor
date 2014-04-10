{$, View} = require 'atom'
Delegator = require 'delegato'
CurveView = require './curve-view'

module.exports =
class BezierCurveEditorView extends View
  Delegator.includeInto(this)

  @content: ->
    @div class: 'bezier-curve-editor overlay', =>
      @subview 'curveView', new CurveView()

  @delegatesMethods 'setSpline', 'renderSpline', toProperty: 'curveView'

  initialize: (serializeState) ->
    atom.workspaceView.command "bezier-curve-editor:toggle", => @toggle()

  open: ->
    @attach()

    @subscribeToOutsideEvent()

    view = atom.workspaceView.getActiveView()


    position = view.pixelPositionForScreenPosition view.editor.getCursorScreenPosition()
    offset = view.offset()

    @css
      top: position.top + offset.top + view.lineHeight + 15
      left: position.left + offset.left + view.find('.gutter').width() - @width() / 2

  subscribeToOutsideEvent: ->
    $body = @parents('body')

    @subscribe $body, 'mousedown', @closeIfClickedOutside

  closeIfClickedOutside: (e) =>
    $target = $(e.target)

    @close() if $target.parents('.bezier-curve-editor').length is 0

  attach: -> atom.workspaceView.append(this)
  close: -> @detach()
  destroy: -> @close()
