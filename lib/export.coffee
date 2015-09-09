fs = require 'fs'
path = require 'path'
apm = require './apm'

module.exports =

  exportConfig: ->
    atomPath = atom.getConfigDirPath()
    savedConfig =
      version:
        1.02
      files: []

    files = fs.readdirSync(atomPath)

    files.push('storage/application.json')

    for file in files
      filePath = path.join(atomPath, file)
      if fs.lstatSync(filePath).isFile()
        temp =
          file: file
          content: fs.readFileSync(filePath)
        savedConfig.files.push(temp)

    fs.writeFileSync("C:/users/derek/savedconfig.json",JSON.stringify(savedConfig))

    ##readConfig = JSON.parse(fs.readFileSync("C:/users/derek/savedconfig.json"))
    ##fs.writeFileSync(path.join(atomPath, 'savedConfig.cson'), new Buffer(readConfig.config))



    console.log savedConfig
    input =
      options:
        cwd: atom.project.getPaths[0]
        env: process.env
      args: ["list"]
    apm.apm(input)
    "Exported a config"
