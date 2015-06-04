{SpacePenDSL, EventsDelegation, AncestorsMethods} = require 'atom-utils'
{CompositeDisposable, Emitter} = require 'atom'
Delegator = require 'delegato'
CurveElement = require './curve-element'
BezierTimingElement = require './bezier-timing-element'
{easing, extraEasing} = require './bezier-functions'

humanize = (str) ->
  str
  .split('_')
  .map((s) -> s.replace(/^./, (m) -> m.toUpperCase()))
  .join(' ')

module.exports =
class BezierCurveEditorElement extends HTMLElement
  Delegator.includeInto(this)
  SpacePenDSL.includeInto(this)
  EventsDelegation.includeInto(this)

  @content: ->
    @div =>
      @tag 'bezier-curve', outlet: 'curveView'
      @tag 'bezier-curve-timing', outlet: 'timingView'

      @div class: 'patterns btn-group', =>
        for name,spline of easing
          @button outlet: name, class: 'btn btn-icon btn-sm', =>
            @i class: 'easing-' + name.replace(/_/g, '-')

        @div class: 'block', =>
          @tag 'select', class: 'form-control', outlet: 'easingSelect', =>
            @tag 'option', value: '', 'More easings...'

            for group, splines of extraEasing
              @tag 'optgroup', label: humanize(group), =>
                for name, spline of splines
                  @tag 'option', value: group + ':' + name, humanize(group + ' ' + name)

      @div class: 'actions btn-group', =>
        @button outlet: 'cancelButton', class: 'btn', 'Cancel'
        @button outlet: 'validateButton', class: 'btn', 'Validate'

  @delegatesMethods 'getSpline', 'setSpline', 'renderSpline', toProperty: 'curveView'

  createdCallback: ->
    @classList.add 'overlay'
    @classList.add 'native-key-bindings'
    @setAttribute('tabindex', -1)

    @subscriptions = new CompositeDisposable
    @emitter = new Emitter

    @subscriptions.add @curveView.onDidChangeSpline =>
      @timingView.setSpline @curveView.getSpline()

    @subscriptions.add @subscribeTo @easingSelect, 'change': =>
      value = @easingSelect.value
      if value isnt ''
        [group, name] = value.split(':')

        @setSpline.apply this, extraEasing[group][name]
        @timingView.setSpline extraEasing[group][name]
        @renderSpline()

    @subscriptions.add @subscribeTo @cancelButton, 'click': =>
      @emitter.emit('did-cancel')

    @subscriptions.add @subscribeTo @validateButton, 'click': =>
      @emitter.emit('did-confirm')

    Object.keys(easing).forEach (name) =>
      button = @[name]
      # button.setTooltip(name.replace /_/g, '-')
      @subscriptions.add @subscribeTo button, 'click': =>
        @setSpline.apply this, easing[name]
        @timingView.setSpline easing[name]
        @renderSpline()

  onDidCancel: (callback) ->
    @emitter.on 'did-cancel', callback

  onDidConfirm: (callback) ->
    @emitter.on 'did-confirm', callback

  open: ->
    @attach()

    @subscribeToOutsideEvent()

    @timingView.setSpline @getSpline()

    @curveView.dummy1.activate()
    @curveView.dummy2.activate()

  subscribeToOutsideEvent: ->
    @subscriptions.add @subscribeTo this, 'mousedown': (e) ->
      e.stopImmediatePropagation()
    @subscriptions.add @subscribeTo document.body, 'mousedown': (e) =>
      @closeIfClickedOutside(e)

  closeIfClickedOutside: (e) ->
    if AncestorsMethods.parents(e.target, '.bezier-curve-editor').length is 0
      @close()

  attach: ->
    editor = @getActiveEditor()
    return if @active or not editor?
    @destroyOverlay()

    if marker = editor.getLastSelection()?.marker
      @overlayDecoration = editor.decorateMarker(marker, {type: 'overlay', item: this, position: 'tail'})
      @active = true

  getActiveEditor: -> atom.workspace.getActiveTextEditor()

  close: ->
    @detach()
    @curveView.dummy1.deactivate()
    @curveView.dummy2.deactivate()

  destroyOverlay: ->
    @active = false
    @overlayDecoration?.destroy()

  detach: ->
    @destroyOverlay()

  destroy: ->
    @close()

module.exports = BezierCurveEditorElement = document.registerElement 'bezier-curve-editor', prototype: BezierCurveEditorElement.prototype
