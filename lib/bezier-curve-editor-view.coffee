{View} = require 'atom'

module.exports =
class BezierCurveEditorView extends View
  @content: ->
    @div class: 'bezier-curve-editor overlay from-top', =>
      @div "The BezierCurveEditor package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "bezier-curve-editor:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "BezierCurveEditorView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
