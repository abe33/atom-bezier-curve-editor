{$, View} = require 'atom-space-pen-views'
Delegator = require 'delegato'
CurveView = require './curve-view'
BezierTimingView = require './bezier-timing-view'
{easing, extraEasing} = require './bezier-functions'

humanize = (str) ->
  str
  .split('_')
  .map((s) -> s.replace(/^./, (m) -> m.toUpperCase()))
  .join(' ')

module.exports =
class BezierCurveEditorView extends View
  Delegator.includeInto(this)

  @content: ->
    @div class: 'bezier-curve-editor overlay native-key-bindings', tabIndex: -1,  =>
      @subview 'curveView', new CurveView()
      @subview 'timingView', new BezierTimingView()

      @div class: 'patterns btn-group', =>
        for name,spline of easing
          @button outlet: name, class: 'btn btn-icon btn-sm', =>
            @i class: 'easing-' + name.replace(/_/g, '-')

        @div class: 'block', =>
          @tag 'select', outlet: 'easingSelect', =>
            @tag 'option', value: '', 'More easings...'

            for group, splines of extraEasing
              @tag 'optgroup', label: humanize(group), =>
                for name, spline of splines
                  @tag 'option', value: group + ':' + name, humanize(group + ' ' + name)

      @div class: 'actions btn-group', =>
        @button outlet: 'cancelButton', class: 'btn', 'Cancel'
        @button outlet: 'validateButton', class: 'btn', 'Validate'

  @delegatesMethods 'getSpline', 'setSpline', 'renderSpline', toProperty: 'curveView'

  initialize: (serializeState) ->
    @curveView.on 'spline:changed', =>
      @timingView.setSpline @curveView.getSpline()

    @easingSelect.on 'change', =>
      value = @easingSelect.val()
      if value isnt ''
        [group, name] = value.split(':')

        @setSpline.apply this, extraEasing[group][name]
        @timingView.setSpline extraEasing[group][name]
        @renderSpline()

    Object.keys(easing).forEach (name) =>
      button = @[name]
      # button.setTooltip(name.replace /_/g, '-')
      button.on 'click', =>
        @setSpline.apply this, easing[name]
        @timingView.setSpline easing[name]
        @renderSpline()

  open: ->
    @attach()

    @subscribeToOutsideEvent()
    @removeClass('arrow-down')

    view = @getActiveEditorView()
    $view = $(view)
    editor = @getActiveEditor()

    cursor = editor.getCursorScreenPosition()
    position = editor.pixelPositionForScreenPosition cursor
    offset = $view.offset()
    gutterWidth = $view.find('.gutter').width()

    top = position.top + view.lineHeight + 15
    left = position.left + gutterWidth - @width() / 2

    if top + @height() > @parents('.scroll-view').find('.underlayer').height()
      top = position.top - 15 - @height()
      @addClass('arrow-down')

    @css {top, left}
    # @timingView.durationEditor.focus()
    @timingView.setSpline @getSpline()

    @curveView.dummy1.activate()
    @curveView.dummy2.activate()

  subscribeToOutsideEvent: ->
    $body = @parents('body')

    @on 'mousedown', (e) -> e.stopImmediatePropagation()
    $body.on 'mousedown', @closeIfClickedOutside

  closeIfClickedOutside: (e) =>
    $target = $(e.target)

    @close() if $target.parents('.bezier-curve-editor').length is 0

  attach: ->
    @getActiveEditorView().querySelector('.overlayer').appendChild(@element)

  getActiveEditor: -> atom.workspace.getActiveEditor()

  getActiveEditorView: -> atom.views.getView(@getActiveEditor())

  close: ->
    @detach()
    @curveView.dummy1.deactivate()
    @curveView.dummy2.deactivate()

  destroy: ->
    @curveView.off()
    @easingSelect.off()
    @close()
