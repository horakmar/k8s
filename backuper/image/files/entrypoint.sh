#!/bin/sh

LOGLEVEL=${LOGLEVEL:-1}

[ $LOGLEVEL -gt 2 ] && set -x

hostname kube5backup
mount -o remount,rw,nosuid,nodev,noexec,relatime /sys

exec "$@"
