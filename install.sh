#!/bin/sh
set -e

# install runit
cp -R /install/runit/* /

apk update --no-cache
# install syslog-ng
apk add syslog-ng
cp -R /install/syslog-ng/* /

# remove install dir
rm -r /install