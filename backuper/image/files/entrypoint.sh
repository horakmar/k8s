#!/bin/sh

LOG_LEVEL=${LOGLEVEL:-2}
export LOG_LEVEL

[ $LOG_LEVEL -gt 3 ] && set -x

exec "$@"
