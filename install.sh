#!/bin/sh
set -e

# install runit
cp -R /install/runit/* /
mkdir /etc/service

# install syslog-ng
apk update
apk add syslog-ng
rm -rf /var/lib/apt/lists/*
#mkdir /var/run/syslog-ng
cp -R /install/syslog-ng/* /

# remove install dir
rm -r /install