{buildMouseEvent} = require './spec-helper'

describe "BezierCurveEditorElement", ->
  [workspaceElement, editor, editorView] = []

  beforeEach ->
    waitsForPromise -> atom.workspace.open('sample.js')

    runs ->
      workspaceElement = atom.views.getView(atom.workspace)
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)

      editor.setText("cubic-bezier(0.3, 0, 0.7, 1)")
      editor.setCursorBufferPosition([4,0])

    waitsForPromise ->
      atom.packages.activatePackage('bezier-curve-editor')

    runs ->
      atom.commands.dispatch(editorView, 'bezier-curve-editor:open')

  describe 'clicking outside the panel', ->
    beforeEach ->
      runs ->
        editorView.dispatchEvent(buildMouseEvent('mousedown'))

    it 'should have removed the view', ->
      expect(editorView.querySelector('bezier-curve-editor')).toBeDefined()
