#!/bin/sh
set -e

# install runit
cp -R /install/runit/* /

# install syslog-ng
apk-install syslog-ng
cp -R /install/syslog-ng/* /

# install initjs
mv /install/initjs/init.js /sbin/initjs

# remove install dir
rm -r /install