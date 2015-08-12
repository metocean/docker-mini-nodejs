#!/bin/sh
set -e

# install runit
cp -R /install/runit/* /

# install syslog-ng
apk-install syslog-ng
cp -R /install/syslog-ng/* /

# install init.sh
mv /install/init.sh /sbin/initsh

# remove install dir
rm -r /install