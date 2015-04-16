#!/bin/sh
mv /install/runit/bin/* /usr/bin
mv /install/runit/sbin/* /usr/sbin
mkdir /etc/service
mv /install/initjs/initjs.js /sbin/initjs
rm -r /install