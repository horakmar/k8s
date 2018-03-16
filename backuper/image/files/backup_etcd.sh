#!/bin/sh
set -eu
[ $LOG_LEVEL -gt 3 ] && set -x

: ${DUMPDIR:=/dbdump}
: ${DUMPSUFFIX:=etcd.backup}
: ${ETCDCTL_API:=3}
export ETCDCTL_API

signalled() {
    echo "### Exited on signal."
    exit 2
}

trap signalled TERM HUP KILL QUIT INT

DUMPFILE=$(date +%F).$DUMPSUFFIX

etcdctl snapshot save $DUMPDIR/$DUMPFILE

dsmc archive -archmc=ARCH1M -archsymlinkasfile=no $DUMPDIR/$DUMPFILE
