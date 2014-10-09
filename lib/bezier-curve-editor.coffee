Debug = require 'prolix'
{Subscriber} = require 'emissary'
BezierCurveEditorView = require './bezier-curve-editor-view'

module.exports = new
class BezierCurveEditor
  Debug('bezier-curve-editor', true).includeInto(this)
  Subscriber.includeInto(this)

  view: null
  match: null
  active: false

  activate: ->
    return if @active

    @active = true
    atom.workspaceView.command "bezier-curve-editor:open", => @open true

    self = this

    atom.contextMenu.add '.editor': [{
      label: 'Edit Bezier Curve',
      command: 'bezier-curve-editor:open',
      shouldDisplay: (event) ->
        return true if self.match = self.getMatchAtCursor()
    }]

    @view = new BezierCurveEditorView

    @subscribe @view.cancelButton, 'click', => @view.close()
    @subscribe @view.validateButton, 'click', =>
      spline = @view.getSpline()
      @replaceMatch(spline)
      @view.close()

  deactivate: ->
    return unless @active

    @active = false
    @view.destroy()

  getMatchAtCursor: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    line = editor.getCursor().getCurrentBufferLine()
    cursorBuffer = editor.getCursorBufferPosition()
    cursorRow = cursorBuffer.row
    cursorColumn = cursorBuffer.column

    matches = @matchesOnLine(line, cursorRow)
    matchAtPos = @matchAtPosition cursorColumn, matches

    return matchAtPos

  matchesOnLine: (line, cursorRow) ->
    float = '(\\d+|\\d?\\.\\d+)'
    regex = ///
      cubic-bezier\s*
      \(\s*
        (#{float})
        \s*,\s*
        (-?#{float})
        \s*,\s*
        (#{float})
        \s*,\s*
        (-?#{float})
      \s*\)
    ///g

    filteredMatches = []
    matches = line.match regex

    return unless matches?

    for match in matches
      continue if (index = line.indexOf match) is -1

      filteredMatches.push
        match: match
        regexMatch: match.match RegExp regex.source, 'i'
        index: index
        end: index + match.length
        row: cursorRow

      line = line.replace match, (Array match.length + 1).join ' '

    return unless filteredMatches.length
    filteredMatches

  matchAtPosition: (column, matches) ->
    return unless column and matches

    for match in matches
      if match.index <= column and match.end >= column
        matchResults = match
        break

    return matchResults

  selectMatch: ->
    editor = atom.workspace.getActiveEditor()

    editor.clearSelections()
    editor.addSelectionForBufferRange
      start:
        column: @match.index
        row: @match.row
      end:
        column: @match.end
        row: @match.row

  replaceMatch: (spline) ->
    return unless @match?

    editor = atom.workspace.getActiveEditor()
    splineCSS = @getSplineCSS(spline)
    editor.replaceSelectedText null, -> splineCSS

    editor.clearSelections()
    editor.addSelectionForBufferRange
      start:
        column: @match.index
        row: @match.row
      end:
        column: @match.index + splineCSS.length
        row: @match.row

  getSplineCSS: (spline) ->
    precision = 100000
    spline = spline.map (n) -> Math.floor(n * precision) / precision

    "cubic-bezier(#{ spline.join ', ' })"

  open: (getMatch = false) ->

    @match = @getMatchAtCursor() if getMatch

    return unless @match?

    [m, a1, _, a2, _, a3, _, a4] = @match.regexMatch
    [a1, a2, a3, a4] = [
      parseFloat a1
      parseFloat a2
      parseFloat a3
      parseFloat a4
    ]

    @view.setSpline(a1, a2, a3, a4)
    @view.renderSpline()
    @view.open()

    @selectMatch()
