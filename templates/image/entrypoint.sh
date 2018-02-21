#!/bin/sh

LOGLEVEL=${LOGLEVEL:-1}

[ $LOGLEVEL -gt 2 ] && set -x

chmod 755 /etc/ssh/keys

exec "$@"
