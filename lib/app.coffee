define (require) ->
  Application = require 'core/app/application'
  HM = require 'core/event/hook_manager'
  Globals = require 'core/model/globals'

  DSCanvas = require 'modules/datasketch/canvas/module'
  DSTools = require 'modules/datasketch/tools/module'
  DSModeTools = require 'modules/datasketch/tools/mode/module'
  DSStrokeTools = require 'modules/datasketch/tools/stroke/module'
  DSColorTools = require 'modules/datasketch/tools/color/module'
  DSTrashTool = require 'modules/datasketch/tools/trash/module'
  WindowResize = require 'modules/windowresize/module'
  KeyboardShortcuts = require 'modules/datasketch/keyboard_shortcuts/module'

  ContextMenu = require 'modules/datasketch/contextmenu/module'
  GroupMenuItem = require 'modules/datasketch/menuitems/group'
  DuplicateMenuItem = require 'modules/datasketch/menuitems/duplicate'
  DeleteMenuItem = require 'modules/datasketch/menuitems/delete'
  IsolateMenuItem = require 'modules/datasketch/menuitems/isolate'
  MapMenuItem = require 'modules/datasketch/menuitems/map'

  DSData = require 'modules/datasketch/data/module'
  Animation = require 'modules/datasketch/animation/module'
  Modal = require 'modules/modal/module'

  require 'link!./style.css'

  class Main extends Application
    constructor: (domRoot) ->
      super domRoot

      HM.hook 'Application.Modules', (set) ->
        set.add DSCanvas
        set.add WindowResize
        set.add DSTools
        set.add DSModeTools
        set.add DSStrokeTools
        set.add DSColorTools
        set.add DSTrashTool
        set.add KeyboardShortcuts
        set.add ContextMenu

        set.add GroupMenuItem
        set.add IsolateMenuItem
        set.add DuplicateMenuItem
        set.add MapMenuItem
        set.add DeleteMenuItem

        set.add DSData
        set.add Animation
        set.add Modal
