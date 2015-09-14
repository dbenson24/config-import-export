fs = require 'fs-plus'
path = require 'path'
apm = require './apm'

module.exports =

  exportConfig: (backupFile) ->
    defaultPath = atom.config.get('config-import-export.defaultPath')
    thePath = defaultPath[process.platform]

    backupFile ?= path.join(thePath, "backup.json")

    atomPath = atom.getConfigDirPath()
    savedConfig =
      version:
        1.02
      files: []
      packages: []

    files = fs.readdirSync(atomPath)

    #files.push('storage/application.json')

    for file in files
      filePath = path.join(atomPath, file)
      if fs.lstatSync(filePath).isFile()
        temp =
          file: file
          content: fs.readFileSync(filePath)
        savedConfig.files.push(temp)

    for packageName in atom.packages.getAvailablePackageNames()
      if atom.packages.isBundledPackage(packageName) is false
        savedConfig.packages.push(packageName)
    fs.writeFileSync(backupFile, JSON.stringify(savedConfig))

    console.log savedConfig
    "Exported a config"
