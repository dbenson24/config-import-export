ConfigImportExportView = require './config-import-export-view'
{CompositeDisposable} = require 'atom'
notifier = require './notifier'
importer = require './import'
exporter = require './export'

module.exports = ConfigImportExport =
  configImportExportView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @configImportExportView = new ConfigImportExportView(state.configImportExportViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @configImportExportView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'config-import-export:export': => @export()
    @subscriptions.add atom.commands.add 'atom-workspace', 'config-import-export:import': => @import()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @configImportExportView.destroy()

  serialize: ->
    configImportExportViewState: @configImportExportView.serialize()

  toggle: ->
    console.log 'ConfigImportExport was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  export: ->
    console.log 'exports was toggled'
    notification = notifier.addSuccess(exporter.exportConfig(), dismissable: true)

  import: ->
    console.log 'imports was toggled'
    notification = notifier.addSuccess(importer.importConfig(), dismissable: true)
