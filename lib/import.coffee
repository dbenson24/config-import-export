fs = require 'fs-plus'
path = require 'path'
apm = require './apm'

module.exports =
  importConfig: (backupFile = "backup.json") ->
    atomPath = atom.getConfigDirPath()
    fileContents = fs.readFileSync(path.join(fs.getHomeDirectory(), "AtomBackups", backupFile))
    readConfig = JSON.parse(fileContents)
    for file in readConfig.files
      fs.writeFileSync(path.join(atomPath, "new" + file.file), new Buffer(file.content))
    "Imported a config"
