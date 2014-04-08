BezierCurveEditorView = require './bezier-curve-editor-view'
ConditionalContextMenu = require './conditional-contextmenu'

module.exports =
  view: null
  match: null

  activate: ->
    atom.workspaceView.command "bezier-curve-editor:open", => @open true

    ConditionalContextMenu.item {
        label: 'Edit Bezier Curve'
        command: 'bezier-curve-editor:open',
    }, => return true if @match = @getMatchAtCursor()

    @view = new BezierCurveEditorView

  deactivate: -> @view.destroy()

  getMatchAtCursor: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    line = editor.getCursor().getCurrentBufferLine()
    cursorBuffer = editor.getCursorBufferPosition()
    cursorRow = cursorBuffer.row
    cursorColumn = cursorBuffer.column

    matches = @matchesOnLine(line, cursorRow)
    matchAtPos = @matchAtPosition cursorColumn, matches

    console.log line, cursorRow, cursorColumn, matches, matchAtPos

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

    _match = do ->
      for match in matches
        return match if match.index <= column and match.end >= column

    return _match

  open: (getMatch = false) ->
