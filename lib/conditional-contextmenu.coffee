
module.exports =
  # Add a context menu item and show it or not based on a condition
  # @Object definition { label: '', command: '' }
  # @Function condition
  item: (definition, condition) ->
    atom.workspaceView.contextmenu ->
      {label, command} = definition

      definitions = atom.contextMenu.definitions['.overlayer']
      hasItem = true for item in definitions when item.label is label and item.command is command

      if condition()
        definitions.unshift {label, command} unless hasItem
      else for item, i in definitions when item
        definitions.splice i, 1 if item.label is label
