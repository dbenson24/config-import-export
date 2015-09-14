fs = require 'fs-plus'
path = require 'path'
apm = require './apm'

module.exports =
  importConfig: (backupFile = "backup.json") ->
    console.log "Import Config Called"
    atomPath = atom.getConfigDirPath()

    defaultPath = atom.config.get('config-import-export.defaultPath')
    thePath = defaultPath[process.platform]

    fileContents = fs.readFileSync(path.join(thePath, backupFile))
    readConfig = JSON.parse(fileContents)
    for file in readConfig.files
      fs.writeFileSync(path.join(atomPath, file.file), new Buffer(file.content))

    for pkg in readConfig.packages
      console.log pkg
      install =
        options:
          cwd: atom.project.getPaths[0]
          env: process.env
        args: ["install",pkg]
      apm.apmAsync(install)
    "Imported a config"
