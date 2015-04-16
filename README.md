# Mini Node.js
A mini Node.js docker based on Alpine Linux / BusyBox

Based on [mhart/alpine-iojs-base](https://github.com/mhart/alpine-node) which is based on [gliderlabs/alpine:3.1](https://github.com/gliderlabs/docker-alpine).

Currently using iojs, but that may change.

Includes runit binaries from [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) and a javascript port of [my_init](https://github.com/phusion/baseimage-docker/blob/master/image/bin/my_init).