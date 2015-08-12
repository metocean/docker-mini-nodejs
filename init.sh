#!/bin/sh

onSIGHUP() {
  echo "INIT: Reloading all services"
  sv reload /etc/service/*
  kill -HUP $pid
}

onSIGINT() {
  echo "INIT: Terminating all services"
  sv down /etc/service/*
  sleep 2
  kill -INT $pid
}

onSIGTERM() {
  echo "INIT: Terminating all services"
  sv down /etc/service/*
  sleep 2
  kill -TERM $pid
}

onSIGCHLD() {
  echo "SIGCHLD"
}

trap onSIGHUP SIGHUP
trap onSIGINT SIGINT
trap onSIGTERM SIGTERM
trap onSIGCHLD SIGCHLD

/usr/bin/runsvdir -P /etc/service &
pid=$!

echo "INIT: $HOSTNAME has started"
wait $pid
echo "INIT: $HOSTNAME has halted"