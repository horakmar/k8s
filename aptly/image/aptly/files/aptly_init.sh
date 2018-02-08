#!/bin/bash -e

USER_ID=${LOCAL_USER_ID:-501}
GROUP_ID=${LOCAL_GROUP_ID:-501}
FULL_NAME=${FULL_NAME:-"Aptly Repo Signing"}
EMAIL_ADDRESS=${EMAIL_ADDRESS:-root@localhost}
GPG_KEY_LENGTH=${GPG_KEY_LENGTH:-4096}
GPG_BINARY=${GPG_BINARY:-gpg1}
# Syslog numeric log level, see https://tools.ietf.org/html/rfc5424
# Defaults to warning
LOG_LEVEL=${LOG_LEVEL:-4}
export HOME=/var/lib/aptly

[ $LOG_LEVEL -gt 6 ] && set -x

log_err() {
    if [[ $LOG_LEVEL -eq 0 ]]; then
        echo "[ERROR] $*" 1>&2
    fi
}

log_warn() {
    if [[ $LOG_LEVEL -gt 3 ]]; then
        echo "[WARN] $*" 1>&2
    fi
}

log_info() {
    if [[ $LOG_LEVEL -gt 5 ]]; then
        echo "[INFO] $*" 1>&2
    fi
}

log_info "Creating user aptly with UID $USER_ID"
getent group aptly >/dev/null || groupadd --system -g $GROUP_ID aptly
getent passwd aptly >/dev/null || useradd --system --shell /bin/bash -u $USER_ID -g aptly -d ${HOME} -m aptly 1>/dev/null 2>/dev/null

if [ $(stat -c '%u' ${HOME}) != $USER_ID ]; then
    log_warn "Fixing ${HOME} permissions.."
    chown -R aptly:aptly ${HOME}
fi

if [ ! -e ${HOME}/.gnupg ]; then
    log_warn "GPG keys not found, please *as user aptly* initialize repository with GPG keys."
	log_warn "Generate signing keypair:"
    log_warn "$GPG_BINARY --batch --gen-key ${HOME}/gpg_batch"
    log_warn "Import distribution keyring:"
	log_warn "for i in /usr/share/keyrings/*; do $GPG_BINARY --no-default-keyring --keyring \$i --export | $GPG_BINARY --import; done"
	log_warn "Store public key in repository:"
    log_warn "$GPG_BINARY --armor --export ${EMAIL_ADDRESS} > ${HOME}/public/public.gpg"
    if [ ! -e ${HOME}/gpg_batch ]; then
	   cat << EOF > ${HOME}/gpg_batch
%echo Generating a default key
Key-Type: RSA
Key-Length: ${GPG_KEY_LENGTH}
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: ${FULL_NAME}
Name-Comment: Aptly repository signing key
Name-Email: ${EMAIL_ADDRESS}
Expire-Date: 0
%no-protection
%commit
%echo done
EOF

      chown aptly:aptly ${HOME}/gpg_batch
    fi
fi

if [ ! -d ${HOME}/public ]; then
    mkdir ${HOME}/public
    chown -R aptly:aptly ${HOME}/public
fi
