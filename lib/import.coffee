fs = require 'fs-plus'
path = require 'path'
apm = require './apm'

module.exports =
  importConfig: (backupFile = "backup.json") ->
    console.log "Import Config Called"
    atomPath = atom.getConfigDirPath()
    fileContents = fs.readFileSync(path.join(fs.getHomeDirectory(), "AtomBackups", backupFile))
    readConfig = JSON.parse(fileContents)
    for file in readConfig.files
      fs.writeFileSync(path.join(atomPath, "new",file.file), new Buffer(file.content))

    for pkg in readConfig.packages
      console.log pkg
      install =
        options:
          cwd: atom.project.getPaths[0]
          env: process.env
        args: ["install",pkg]
      #apm.apm(install)
    "Imported a config"
