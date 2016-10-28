#!/bin/sh
set -e

# install runit
cp -R /install/runit/* /

# install syslog-ng
apk add --update syslog-ng
cp -R /install/syslog-ng/* /

# remove install dir
rm -r /install
