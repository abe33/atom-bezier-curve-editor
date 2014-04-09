Debug = require 'prolix'

BezierCurveEditorView = require './bezier-curve-editor-view'
ConditionalContextMenu = require './conditional-contextmenu'
{keySpline, easing} = require './bezier-functions'

module.exports = new
class BezierCurveEditor
  Debug('bezier-curve-editor', true).includeInto(this)

  view: null
  match: null
  active: false

  activate: ->
    return if @active

    @active = true
    atom.workspaceView.command "bezier-curve-editor:open", => @open true

    ConditionalContextMenu.item {
      label: 'Edit Bezier Curve'
      command: 'bezier-curve-editor:open',
    }, => return true if @match = @getMatchAtCursor()

    @view = new BezierCurveEditorView

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
    regex = ///
      cubic-bezier\s*
      \(\s*
        (\d+(\.\d+)?)
        \s*,\s*
        (-?\d+(\.\d+)?)
        \s*,\s*
        (\d+(\.\d+)?)
        \s*,\s*
        (-?\d+(\.\d+)?)
      \s*\)
    ///g

    filteredMatches = []
    matches = line.match regex

    return unless matches?

    for match in matches
      # Skip if the match has “been used” already
      continue if (index = line.indexOf match) is -1

      filteredMatches.push
        match: match
        regexMatch: match.match RegExp regex.source, 'i'
        index: index
        end: index + match.length
        row: cursorRow

      # Make sure the indices are correct by removing
      # the instances from the string after use
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

    @log a1,a2,a3,a4

    @view.setSpline keySpline(a1, a2, a3, a4)
    @view.renderSpline()
    @view.open()
