ConfigImportExportView = require './config-import-export-view'
{CompositeDisposable} = require 'atom'

module.exports = ConfigImportExport =
  configImportExportView: null
  subscriptions: null

  activate: (state) ->
    @view = new ConfigImportExportView()


  deactivate: ->
    @view?.destroy()

  serialize: ->


  export: ->
    console.log 'exports was toggled'
    ConfigImportExportView.attach()

  import: ->
    console.log 'imports was toggled'
    ConfigImportExportView.attach()
