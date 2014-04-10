{$, View} = require 'atom'
Delegator = require 'delegato'
CurveView = require './curve-view'

module.exports =
class BezierCurveEditorView extends View
  Delegator.includeInto(this)

  @content: ->
    @div class: 'bezier-curve-editor overlay', =>
      @subview 'curveView', new CurveView()

      @div class: 'btn-group', =>
        @button outlet: 'cancelButton', class: 'btn', 'Cancel'
        @button outlet: 'validateButton', class: 'btn', 'Validate'

  @delegatesMethods 'getSpline', 'setSpline', 'renderSpline', toProperty: 'curveView'

  initialize: (serializeState) ->
    atom.workspaceView.command "bezier-curve-editor:toggle", => @toggle()

  open: ->
    @attach()

    @subscribeToOutsideEvent()

    view = atom.workspaceView.getActiveView()

    cursor = view.editor.getCursorScreenPosition()
    position = view.pixelPositionForScreenPosition cursor
    offset = view.offset()
    gutterWidth = view.find('.gutter').width()

    @css
      top: position.top + offset.top + view.lineHeight + 15
      left: position.left + offset.left + gutterWidth - @width() / 2

  subscribeToOutsideEvent: ->
    $body = @parents('body')

    @subscribe $body, 'mousedown', @closeIfClickedOutside

  closeIfClickedOutside: (e) =>
    $target = $(e.target)

    @close() if $target.parents('.bezier-curve-editor').length is 0

  attach: -> atom.workspaceView.append(this)
  close: -> @detach()
  destroy: -> @close()
