#!/bin/sh
set -eu
[ $LOG_LEVEL -gt 3 ] && set -x

: ${DUMPDIR:=/dbdump}
: ${DUMPSUFFIX:=zabbix.dump}

DUMPFILE=$(date +%F).$DUMPSUFFIX

pg_dump -Fc -w -v >$DUMPDIR/$DUMPFILE

dsmc archive -archmc=ARCH1M -archsymlinkasfile=no $DUMPDIR/$DUMPFILE
