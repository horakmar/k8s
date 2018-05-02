#!/bin/bash

SCRIPT=$(basename $0)
MAXTRIES=3
VERBOSE=0
SNAPSHOT=0

log_error() {
    echo "[ERROR] $*" >&2
}

log_info() {
    [ $VERBOSE -eq 1 ] && echo "[INFO] $*"
}

if [[ "$*" == *--verbose* || "$*" == *-v* ]]; then
    VERBOSE=1
fi

if [[ "$*" == *--snapshot* || "$*" == *-s* ]]; then
    SNAPSHOT=1
fi

publish_find_from_snapshot() {
    snapshot=$1
    publish_list=$(aptly publish list -raw | tr ' ' ',')
    for l in $publish_list; do 
        if aptly publish show ${l#*,} ${l%,*} | grep -qF "$snapshot [snapshot]"; then
            echo "${l#*,} ${l%,*}"
        fi
    done
}

MIRRORS=$(aptly mirror list -raw 2>&1)
if [[ $? -ne 0 ]]; then
    log_error "$MIRRORS"
    exit 1
fi

for mirror in $MIRRORS; do
    try=0
    retval=66

    while [[ $retval -ne 0 && $try -lt $MAXTRIES ]]; do
        log_info "Starting update of mirror ${mirror}"
        if [[ $VERBOSE -eq 0 ]]; then
            out=$(aptly mirror update -force=true ${mirror} >/dev/null 2>&1)
        else
            aptly mirror update -force=true ${mirror}
        fi

        retval=$?
        if [[ $retval -ne 0 ]]; then
            try=$[ $try + 1 ]
            log_error "Failed to update mirror ${mirror}, try=${try}"
            [ -n "$out" ] && log_error "${out}"
        else
            log_info "Synced mirror ${mirror}"
            if [[ $SNAPSHOT -eq 1 ]]; then
                old_snapshot=$(aptly snapshot list -raw | grep -P "^${mirror}-\d+$")
                snapshot_name="${mirror}-$(date +%s)"
                if [[ $VERBOSE -eq 0 ]]; then
                    out=$(aptly snapshot create ${snapshot_name} from mirror ${mirror} >/dev/null 2>&1)
                else
                    aptly snapshot create ${snapshot_name} from mirror ${mirror}
                fi

                retval=$?
                if [[ $retval -ne 0 ]]; then
                    log_error "Failed to create snapshot ${snapshot_name} from mirror ${mirror}"
                    [ -n "$out" ] && log_error "$out"
                else
                    log_info "Created snapshot ${snapshot_name} from mirror ${mirror}"
                fi
                if [[ -n "$old_snapshot" ]] ; then
                    if aptly snapshot diff $old_snapshot $snapshot_name | grep -qvF "Snapshots are identical"; then
                        publish=$(publish_find_from_snapshot $old_snapshot)
                        log_info "Snapshots $old_snapshot and $snapshot_name differs, switching publish $publish."
                        if [[ -n "$publish" ]]; then
                            if [[ $VERBOSE -eq 0 ]]; then
                                out=$(aptly publish switch $publish ${snapshot_name} >/dev/null 2>&1)
                            else
                                aptly publish switch $publish ${snapshot_name}
                            fi

                            retval=$?
                            if [[ $retval -ne 0 ]]; then
                                log_error "Failed to publish snapshot ${snapshot_name} as $publish."
                                [ -n "$out" ] && log_error "$out"
                                aptly snapshot drop ${snapshot_name}
                            else
                                log_info "Published snapshot ${snapshot_name} as $publish. Dropping ${old_snapshot}"
                                aptly snapshot drop ${old_snapshot}
                            fi
                        fi
                    else
                        log_info "Snapshots are identical, dropping ${snapshot_name}."
                        aptly snapshot drop ${snapshot_name}
                    fi
                fi
            fi
            break
        fi
    done
done

