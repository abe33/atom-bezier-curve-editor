{WorkspaceView} = require 'atom'
BezierCurveEditor = require '../lib/bezier-curve-editor'

describe "BezierCurveEditor", ->
  beforeEach ->
    waitsForPromise ->
      atom.workspaceView = new WorkspaceView
      atom.packages.activatePackage('bezier-curve-editor')
