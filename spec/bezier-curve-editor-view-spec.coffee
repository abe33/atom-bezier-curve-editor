BezierCurveEditorView = require '../lib/bezier-curve-editor-view'
{WorkspaceView} = require 'atom'

describe "BezierCurveEditorView", ->
  beforeEach ->
    runs ->
      atom.workspaceView = new WorkspaceView
      atom.workspaceView.attachToDom()
      atom.workspaceView.openSync('sample.js')

    runs ->
      @editorView = atom.workspaceView.getActiveView()
      @editorView.setText("cubic-bezier(0.3, 0, 0.7, 1)")
      @editorView.editor.setCursorBufferPosition([4,0])

    waitsForPromise ->
      atom.packages.activatePackage('bezier-curve-editor')

    runs ->
      atom.workspaceView.trigger 'bezier-curve-editor:open'

  describe 'clicking outside the panel', ->
    beforeEach ->
      runs ->
        atom.workspaceView.trigger('mousedown')

    it 'should have removed the view', ->
      expect(atom.workspaceView.find('.bezier-curve-editor').length).toEqual(0)
