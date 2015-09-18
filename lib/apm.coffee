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
      notifier.addError out.stderr.toString(), dismissable:true
    if (out.stdout.length > 0)
      notifier.addSuccess out.stdout.toString(), dismissable:true

  apmAsync: ({args, cwd, options, stdout, stderr, exit}={}) ->
    command = atom.packages.getApmPath()
    options ?= {}
    options.cwd ?= cwd
    out = child_process.spawn(command, args, options)
    stdout = ""
    stderr = ""
    out.stderr.on 'data', (data) ->
      stderr += data.toString()
    out.stdout.on 'data', (data) ->
      stdout += data.toString()
    out.on 'close', (code) ->
      if stderr.length > 0
        notifier.addError stderr.toString(), dismissable: true
      if stdout.length > 0
        notifier.addSuccess stdout.toString(), dismissable: true
