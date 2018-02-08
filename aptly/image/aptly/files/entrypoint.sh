#!/bin/bash -e

[ -x /usr/local/bin/aptly_init.sh ] && /usr/local/bin/aptly_init.sh

exec "$@"
