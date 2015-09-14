ConfigExportView = require './config-export-view'
ConfigImportView = require './config-import-view'
fs = require 'fs-plus'
path = require 'path'
{CompositeDisposable} = require 'atom'

module.exports = ConfigImportExport =
  configImportExportView: null
  subscriptions: null

  activate: (state) ->
    defaultPath = atom.config.get('config-import-export.defaultPath')
    defaultPath ?= {}
    thePath = defaultPath[process.platform]
    thePath ?= ""
    if thePath is "" or !fs.existsSync(thePath)
      defaultPath[process.platform] = path.join fs.getHomeDirectory(), "AtomBackups"
      atom.config.set('config-import-export.defaultPath', defaultPath)

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

  config:
    defaultPath:
      type: 'object'
      properties:
        win32:
          type: 'string'
          default: ''
        darwin:
          type: 'string'
          default: ''
        linux:
          type: 'string'
          default: ''
        freebsd:
          type: 'string'
          default: ''
        sunos:
          type: 'string'
          default: ''
