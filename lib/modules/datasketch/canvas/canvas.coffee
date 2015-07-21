define (require) ->
  Controller = require 'core/controller/controller'
  View = require './view'
  Model = require './model'
  Globals = require 'core/model/globals'

  Path = require './objects/path'
  Group = require './objects/group'

  class DSCanvas extends Controller
    constructor: (config) ->
      config ?= {}
      config.modelClass ?= Model
      config.viewClass ?= View

      super config

      @_model.addEventListener 'Model.Change', @_onModelChange
      @view().addEventListener 'Selection.Created', @_onSelectionCreated
      @view().addEventListener 'Selection.Cleared', @_onSelectionCleared
      @view().addEventListener 'Path.Created', @_onPathCreated

    getMode: () =>
      @_model.get 'mode'

    setMode: (mode) =>
      @_model.set 'mode', mode

    getStrokeWidth: () =>
      @_model.get 'strokeWidth'

    setStrokeWidth: (width) =>
      @_model.set 'strokeWidth', width

    getStrokeColor: () =>
      @_model.get 'strokeColor'

    setStrokeColor: (color) =>
      @_model.set 'strokeColor', color

    getSelectedObjects: () =>
      @_model.get 'selected'

    selectObjects: (objects) =>
      objectIds = (obj.get('id') for obj in objects)
      @_model.set 'selected', (obj for obj in @_model.get('objects') when obj.get('id') in objectIds)

    addObject: (object, silent = false) =>
      @_model.addObject object, silent

    addObjects: (objects) =>
      @_model.addObjects objects

    removeObject: (object) =>
      @_model.removeObject object

    removeObjects: (objects) =>
      @_model.removeObjects objects

    removeSelected: () =>
      @_model.removeSelected()

    createGroup: (objects) =>
      if !objects?
        objects = @_model.get 'selected'
      if !objects?
        return null

      group = new Group objects
      @addObject group
      @removeObjects objects
      @selectObjects [group]
      group

    breakGroup: (group) =>
      @removeObject group
      @addObjects group.getObjects()
      group.getObjects()

    _onModelChange: (evt) =>
      switch evt.data.path
        when "strokeWidth"
          @dispatchEvent "Canvas.StrokeWidthChange",
            width: evt.data.value
        when "mode"
          @dispatchEvent "Canvas.ModeChange",
            mode: evt.data.value
        when "strokeColor"
          @dispatchEvent "Canvas.StrokeColorChange",
            color: evt.data.value
        when "selected"
          if evt.data.value?.length
            Globals.get('Relay').dispatchEvent 'ContextMenu.RequestDisplay',
              context:
                selection: evt.data.value
          else
            Globals.get('Relay').dispatchEvent 'ContextMenu.RequestClose', {}

    _onPathCreated: (evt) =>
      @_model.addObject evt.data.path, true

    _onSelectionCreated: (evt) =>
      @selectObjects evt.data.objects

    _onSelectionCleared: (evt) =>
      @selectObjects []

    initCanvas: () =>
      @_view.initCanvas @_model