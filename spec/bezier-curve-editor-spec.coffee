{WorkspaceView} = require 'atom'
BezierCurveEditor = require '../lib/bezier-curve-editor'

describe "BezierCurveEditor", ->
  afterEach -> BezierCurveEditor.deactivate()

  beforeEach ->
    runs ->
      atom.workspaceView = new WorkspaceView
      atom.workspaceView.attachToDom()
      atom.workspaceView.openSync('sample.js')

    runs ->
      @editorView = atom.workspaceView.getActiveView()
      @editorView.setText("cubic-bezier(0.3, 0, .7, 1)")
      @editorView.editor.setCursorBufferPosition([4,0])

    waitsForPromise ->
      atom.packages.activatePackage('bezier-curve-editor')

  it 'should be active', ->
    expect(BezierCurveEditor.active).toBeTruthy()

  describe 'triggering the open command', ->
    beforeEach ->
      runs ->
        atom.workspaceView.trigger 'bezier-curve-editor:open'

    it 'should have opened the view', ->
      expect(atom.workspaceView.find('.bezier-curve-editor').length).toEqual(1)
