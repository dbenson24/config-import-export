ConfigExportView = require './config-export-view'
ConfigImportView = require './config-import-view'
{CompositeDisposable} = require 'atom'

module.exports = ConfigImportExport =
  configImportExportView: null
  subscriptions: null

  activate: (state) ->
    @importView = new ConfigImportView()
    @exportView = new ConfigExportView()


  deactivate: ->
    @importView?.destroy()
    @exportView?.destroy()

  serialize: ->


  export: ->
    console.log 'exports was toggled'
    @exportView.attach()

  import: ->
    console.log 'imports was toggled'
    @importView.attach()
