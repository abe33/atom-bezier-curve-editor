{$, View} = require 'atom'
Delegator = require 'delegato'
CurveView = require './curve-view'
{easing} = require './bezier-functions'

module.exports =
class BezierCurveEditorView extends View
  Delegator.includeInto(this)

  @content: ->
    @div class: 'bezier-curve-editor overlay', =>
      @subview 'curveView', new CurveView()

      @div class: 'patterns btn-group', =>
        for name,spline of easing
          @button outlet: name, class: 'btn btn-sm', =>
            @i class: 'easing-' + name.replace(/_/g, '-')

      @div class: 'actions btn-group', =>
        @button outlet: 'cancelButton', class: 'btn', 'Cancel'
        @button outlet: 'validateButton', class: 'btn', 'Validate'

  @delegatesMethods 'getSpline', 'setSpline', 'renderSpline', toProperty: 'curveView'

  initialize: (serializeState) ->
    atom.workspaceView.command "bezier-curve-editor:toggle", => @toggle()

    Object.keys(easing).forEach (name) =>
      button = @[name]
      button.setTooltip(name.replace /_/g, '-')
      @subscribe button, 'click', =>
        @setSpline.apply this, easing[name]
        @renderSpline()

  open: ->
    @attach()

    @subscribeToOutsideEvent()
    @removeClass('arrow-down')

    view = atom.workspaceView.getActiveView()

    cursor = view.editor.getCursorScreenPosition()
    position = view.pixelPositionForScreenPosition cursor
    offset = view.offset()
    gutterWidth = view.find('.gutter').width()

    top = position.top + view.lineHeight + 15
    left = position.left + gutterWidth - @width() / 2

    if top + @height() > @parent().height()
      top = position.top - 15 - @height()
      @addClass('arrow-down')

    @css {top, left}

  subscribeToOutsideEvent: ->
    $body = @parents('body')

    @on 'mousedown', (e) -> e.stopImmediatePropagation()
    @subscribe $body, 'mousedown', @closeIfClickedOutside

  closeIfClickedOutside: (e) =>
    $target = $(e.target)

    @close() if $target.parents('.bezier-curve-editor').length is 0

  attach: ->
    atom.workspaceView.getActiveView().overlayer.append(this)

  close: -> @detach()
  destroy: -> @close()
  getModel: -> {}
