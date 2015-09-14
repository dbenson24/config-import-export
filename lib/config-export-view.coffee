path = require 'path'
{$, TextEditorView, View} = require 'atom-space-pen-views'
{BufferedProcess} = require 'atom'
fs = require 'fs-plus'
notifier = require './notifier'
importer = require './import'
exporter = require './export'


module.exports =
class ExportView extends View
  previouslyFocusedElement: null
  mode: null

  export: (file) ->
    notification = notifier.addSuccess(exporter.exportConfig(file), dismissable: true)

  @content: ->
    @div class: 'config-import-export', =>
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'error', outlet: 'error'
      @div class: 'message', outlet: 'message'

  initialize: ->

    @commandSubscription = atom.commands.add 'atom-workspace',
      'config-import-export:export': => @attach('export')

    @miniEditor.on 'blur', => @close()
    atom.commands.add @element,
      'core:confirm': => @confirm()
      'core:cancel': => @close()

  destroy: ->
    @panel?.destroy()

  attach: (@mode) ->
    @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
    @previouslyFocusedElement = $(document.activeElement)
    @panel.show()
    @message.text("Enter the backup path")
    @setPathText("myBackup.json")
    @miniEditor.focus()

  setPathText: (placeholderName, rangeToSelect) ->
    editor = @miniEditor.getModel()
    rangeToSelect ?= [0, placeholderName.length-5]
    defaultPath = atom.config.get('config-import-export.defaultPath')
    backupDirectory = defaultPath[process.platform]

    editor.setText(path.join(backupDirectory, placeholderName))
    pathLength = editor.getText().length
    endOfDirectoryIndex = pathLength - placeholderName.length
    editor.setSelectedBufferRange([[0, endOfDirectoryIndex + rangeToSelect[0]], [0, endOfDirectoryIndex + rangeToSelect[1]]])

  close: ->
    return unless @panel.isVisible()
    @panel.hide()
    @previouslyFocusedElement?.focus()

  confirm: ->
    if @validBackupPath()
      @export(@getBackupPath())
      @close()

  getBackupPath: ->
    fs.normalize(@miniEditor.getText().trim())

  validBackupPath: ->
    if fs.existsSync(@getBackupPath())
      @error.text("File already exists at '#{@getBackupPath()}'")
      @error.show()
      false
    else
      true
