#!/bin/sh

[ $LOG_LEVEL -gt 3 ] && set -x

unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

# Variables with default values
: ${CEPH_USER:=kube}
: ${CEPH_POOL:=kube}
: ${BACKUP_PVC:=doku-data}
: ${BACKUP_MOUNT:=/mnt/dokuwiki}
: ${LOG_LEVEL:=3}

MADE_SNAP=false
MADE_MAP=false
MADE_MOUNT=false

# For RBD block devices manipulation
mount -o remount,rw,nosuid,nodev,noexec,relatime /sys

log_err() {
    if [ $LOG_LEVEL -gt 0 ]; then
        echo "[ERROR] $*" 1>&2
    fi
    cleanup
    exit 1
}

log_warn() {
    if [ $LOG_LEVEL -gt 1 ]; then
        echo "[WARN] $*" 1>&2
    fi
}

log_info() {
    if [ $LOG_LEVEL -gt 2 ]; then
        echo "[INFO] $*" 1>&2
    fi
}

cleanup() {
    if $MADE_MOUNT ; then
        umount $RBD_DEV || log_warn "Cannot unmount snapshot dev $RBD_DEV from $BACKUP_MOUNT."
    fi
    if $MADE_MAP ; then
        $RBD unmap $SNAP || log_warn "Cannot unmap snapshot $SNAP."
    fi
    if $MADE_SNAP ; then
        $RBD snap rm $SNAP || log_warn "Cannot remove snapshot $SNAP."
    fi
}

signalled() {
    cleanup
    echo "### Exited on signal."
    exit 2
}

trap signalled TERM HUP KILL QUIT INT

RBD="rbd --user $CEPH_USER"
KCTL="kubectl --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt --token=$(cat /run/secrets/kubernetes.io/serviceaccount/token) --server=https://kubernetes.default.svc"

PV=$($KCTL get pvc $BACKUP_PVC -o jsonpath='{.spec.volumeName}')
[ $? != 0 ] && log_err "Cannot find PVC $BACKUP_PVC in cluster."

VOLUME=$($KCTL get pv $PV -o jsonpath='{.spec.rbd.image}')
[ $? != 0 ] && log_err "Cannot find PV $PV in cluster."
SNAP="${CEPH_POOL}/${VOLUME}@s1"

log_info "### Backup started."

ssh -o StrictHostKeyChecking=no -o CheckHostIP=no -i /etc/keys/dokuwiki/cmd.key cmd@dokuwiki1 sudo fsfreeze --freeze /data
[ $? != 0 ] && log_warn "Cannot freeze FS."

$RBD snap create $SNAP
SNAP_RC=$?

ssh -o StrictHostKeyChecking=no -o CheckHostIP=no -i /etc/keys/dokuwiki/cmd.key cmd@dokuwiki1 sudo fsfreeze --unfreeze /data
[ $? != 0 ] && log_warn "Cannot unfreeze FS."

[ $SNAP_RC != 0 ] && log_err "Cannot create snapshot $SNAP."
MADE_SNAP=true

# Pod must have hostNetwork = true, otherwise map blocks
RBD_DEV=$($RBD map $SNAP)
[ $? != 0 ] && log_err "Cannot map snapshot $SNAP."
MADE_MAP=true

mkdir -p $BACKUP_MOUNT
mount -o ro $RBD_DEV $BACKUP_MOUNT
[ $? != 0 ] && log_err "Cannot mount snapshot dev $RBD_DEV to $BACKUP_MOUNT."
MADE_MOUNT=true

dsmc incr ${BACKUP_MOUNT}/ -sub=yes
[ $? != 0 ] && log_warn "Backup exited with error core $?."

cleanup

log_info "### Backup completed."
