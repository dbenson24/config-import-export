notifier = require './notifier'
sys = require 'sys'
child_process = require 'child_process'

module.exports =
  apm: ({args, cwd, options, stdout, stderr, exit}={}) ->
    command = atom.packages.getApmPath()
    options ?= {}
    options.cwd ?= cwd
    out = child_process.spawnSync(command, args, options)
    console.log(out)
    if (out.stderr.length > 0)
      notifier.addError out.stderr.toString()
    if (out.stdout.length > 0)
      notifier.addSuccess out.stdout.toString()

###
module.exports =
  apm: ({args, cwd, options, stdout, stderr, exit}={}) ->
    command = atom.packages.getApmPath()
    options ?= {}
    options.cwd ?= cwd
    stderr ?= (data) -> notifier.addError data.toString()

    if stdout? and not exit?
      c_stdout = stdout
      stdout = (data) ->
        notifier.addInfo data.toString()
      exit = (exit) ->
        c_stdout @save ?= ''
        @save = null

    try
      new BufferedProcess
        command: command
        args: args
        options: options
        stdout: stdout
        stderr: stderr
        exit: exit
    catch error
      notifier.addError 'apm is not a valid command. Please ensure that apm\'s binary is located on process.env.path'
###
