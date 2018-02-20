#!/bin/sh

DEBUG=${DEBUG:-0}

[ $DEBUG -gt 0 ] && set -x

chmod 755 /etc/ssh/keys

exec "$@"
