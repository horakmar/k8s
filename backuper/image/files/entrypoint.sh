#!/bin/sh

LOG_LEVEL=${LOGLEVEL:-2}

[ $LOG_LEVEL -gt 3 ] && set -x

# hostname kube5backup
mount -o remount,rw,nosuid,nodev,noexec,relatime /sys

exec "$@"
