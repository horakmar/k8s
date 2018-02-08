#!/bin/bash -e

[ -x /usr/local/bin/aptly_init.sh ] && /usr/local/bin/aptly_init.sh
[ -x /usr/local/bin/sshd_init.sh ] && /usr/local/bin/sshd_init.sh

exec "$@"
