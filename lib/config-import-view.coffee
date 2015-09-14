path = require 'path'
{$, TextEditorView, View, SelectListView} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs-plus'
notifier = require './notifier'
importer = require './import'

module.exports =
class ImportView extends SelectListView
  previouslyFocusedElement: null
  mode: null

  import: (file) ->
    notification = notifier.addSuccess(importer.importConfig(file), dismissable: true)

  initialize: ->
    super
    @commandSubscription = atom.commands.add 'atom-workspace',
      'config-import-export:import': => @attach('import')
    @addClass('overlay from-top')

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (file) ->
    notification = notifier.addSuccess(importer.importConfig(file), dismissable: true)
    @close()

  cancelled: ->
    @close()

  destroy: ->
    @panel?.destroy()

  attach: (@mode) ->
    @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
    @previouslyFocusedElement = $(document.activeElement)
    files = fs.readdirSync(path.join(fs.getHomeDirectory(), 'AtomBackups'))
    @setItems(files)
    @panel.show()
    @focusFilterEditor()

  close: ->
    return unless @panel.isVisible()
    @panel.hide()
    @previouslyFocusedElement?.focus()
