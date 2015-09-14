fs = require 'fs-plus'
path = require 'path'
apm = require './apm'

module.exports =

  exportConfig: ->
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
    fs.writeFileSync(path.join(fs.getHomeDirectory(), "AtomBackups", "backup.json"),JSON.stringify(savedConfig))

    console.log savedConfig
    "Exported a config"
