#!/usr/bin/env coffee
{ spawn, exec } = require 'child_process'

isrunning = (pid) ->
  try
    return process.kill pid, 0
  catch e
    return e.code is 'EPERM'

graceful = (pid) ->
  process.kill pid
  setTimeout (-> terminate pid), 5000
terminate = (pid) ->
  return if !isrunning(pid)
  process.kill pid, 'SIGKILL'

command =
  up: ->
    return if command.pid?
    console.log 'up'
    ref = spawn '/usr/bin/runsvdir', [
      '-P'
      '/etc/service'
    ]
    ref.on 'exit', command.exit
    ref.stdout.on 'data', (data) -> command.stdout data.toString()
    ref.stderr.on 'data', (data) -> command.stderr data.toString()
    command.pid = ref.pid
    console.log 'started'
  down: ->
    return if !command.pid?
    console.log 'down'
    exec '/usr/bin/sv down /etc/service/*'
      .on 'exit', command.graceful
  reload: ->
    return if !command.pid?
    console.log 'reload'
    process.kill command.pid, 'SIGHUP'
  graceful: ->
    return if !command.pid?
    console.log 'graceful shutdown'
    graceful command.pid
  terminate: ->
    return if !command.pid?
    console.log 'terminating'
    terminate command.pid
  exit: (code, signal) ->
    delete command.pid
    if code?
      console.log "exit(#{code})"
      process.exit code
      return
    console.log "exit(#{signal})"
    process.exit 2
  error: (error) -> console.error error
  stdout: (data) -> console.log data
  stderr: (data) -> console.error data

process.on 'exit', ->
  command.graceful()
process.on 'uncaughtException', (error) ->
  console.error error.stack
  command.graceful()
process.on 'SIGTERM', ->
  console.log 'SIGTERM'
  command.down()
process.on 'SIGINT', ->
  console.log 'SIGINT'
  command.down()
process.on 'SIGHUP', ->
  console.log 'SIGHUP'
  command.reload()
process.on 'SIGCHLD', ->
  console.log 'SIGCHILD'

command.up()