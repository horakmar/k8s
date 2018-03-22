#!/bin/bash -e

LOG_LEVEL=${LOGLEVEL:-2}
export LOG_LEVEL

[ $LOG_LEVEL -gt 3 ] && set -x

[ -x /usr/local/bin/sshd_init.sh ] && /usr/local/bin/sshd_init.sh

exec "$@"
