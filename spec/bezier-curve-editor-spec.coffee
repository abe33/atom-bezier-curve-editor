BezierCurveEditor = require '../lib/bezier-curve-editor'

describe "BezierCurveEditor", ->
  [workspaceElement, editor, editorView] = []

  afterEach -> BezierCurveEditor.deactivate()

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

  describe 'triggering the open command', ->
    beforeEach ->
      runs ->
        atom.commands.dispatch workspaceElement, 'bezier-curve-editor:open'

    it 'should have opened the view', ->
      expect(editorView.querySelector('.bezier-curve-editor')).toBeDefined()
