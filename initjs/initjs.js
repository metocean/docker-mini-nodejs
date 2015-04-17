#!/usr/bin/env node
var child_process = require('child_process');
var spawn = child_process.spawn;
var exec = child_process.exec;

var isrunning = function(pid) {
  try {
    return process.kill(pid, 0);
  } catch (_error) {
    return _error.code === 'EPERM';
  }
};

var graceful = function(pid) {
  process.kill(pid);
  setTimeout((function() { terminate(pid); }), 5000);
};

var terminate = function(pid) {
  if (!isrunning(pid)) { return; }
  process.kill(pid, 'SIGKILL');
};

var command = {
  up: function() {
    if (command.pid != null) { return; }
    console.log('up');
    var run = spawn('/usr/bin/runsvdir', ['-P', '/etc/service']);
    run.on('exit', command.exit);
    run.stdout.on('data', function(data) {
      command.stdout(data.toString());
    });
    run.stderr.on('data', function(data) {
      command.stderr(data.toString());
    });
    command.pid = run.pid;
    console.log('started');
  },
  down: function() {
    if (command.pid == null) { return; }
    console.log('down');
    exec('/usr/bin/sv down /etc/service/*').on('exit', command.graceful);
  },
  reload: function() {
    if (command.pid == null) { return; }
    console.log('reload');
    process.kill(command.pid, 'SIGHUP');
  },
  graceful: function() {
    if (command.pid == null) { return; }
    console.log('graceful shutdown');
    graceful(command.pid);
  },
  terminate: function() {
    if (command.pid == null) { return; }
    console.log('terminating');
    terminate(command.pid);
  },
  exit: function(code, signal) {
    delete command.pid;
    if (code != null) {
      console.log("exit(" + code + ")");
      process.exit(code);
      return;
    }
    console.log("exit(" + signal + ")");
    process.exit(2);
  },
  error: function(error) { console.error(error); },
  stdout: function(data) { console.log(data); },
  stderr: function(data) { console.error(data); }
};

process.on('exit', function() {
  command.graceful();
});
process.on('uncaughtException', function(error) {
  console.error(error.stack);
  command.graceful();
});
process.on('SIGTERM', function() {
  console.log('SIGTERM');
  command.down();
});
process.on('SIGINT', function() {
  console.log('SIGINT');
  command.down();
});
process.on('SIGHUP', function() {
  console.log('SIGHUP');
  command.reload();
});
process.on('SIGCHLD', function() {
  console.log('SIGCHILD');
});

command.up();
