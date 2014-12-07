module.exports =
  buildMouseEvent: (type, properties={}) ->
      defaults = {bubbles: true, cancelable: true}
      defaults[k] = v for k,v of properties
      properties.detail ?= 1
      event = new MouseEvent(type, properties)
      Object.defineProperty(event, 'which', get: -> properties.which) if properties.which?
      if properties.target?
        Object.defineProperty(event, 'target', get: -> properties.target)
        Object.defineProperty(event, 'srcObject', get: -> properties.target)
      event
