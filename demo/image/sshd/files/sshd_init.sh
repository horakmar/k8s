#!/bin/bash -e

: ${LOGLEVEL:=2}
[ $LOG_LEVEL -gt 3 ] && set -x


# Fix permissions, if writable
if [ -w ~/.ssh ]; then
    chown root:root ~/.ssh && chmod 700 ~/.ssh/
fi
if [ -w ~/.ssh/authorized_keys ]; then
    chown root:root ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi
if [ -w /etc/ssh/keys ]; then
    chown root:root /etc/ssh/keys
    chmod 755 /etc/ssh/keys
    find /etc/ssh/keys/ -type f -exec chmod 644 {} \;
fi

# Add users if SSH_USERS=user:uid:gid set
if [ -n "${SSH_USERS}" ]; then
    USERS=$(echo $SSH_USERS | tr "," "\n")
    for U in $USERS; do
        IFS=':' read -ra UA <<< "$U"
        _NAME=${UA[0]}
        _UID=${UA[1]}
        _GID=${UA[2]}

        echo ">> Adding user ${_NAME} with uid: ${_UID}, gid: ${_GID}."
        if [ ! -e "/etc/authorized_keys/${_NAME}" ]; then
            echo "WARNING: No SSH authorized_keys found for ${_NAME}!"
        fi
        getent group ${_NAME} >/dev/null 2>&1 || groupadd -g ${_GID} ${_NAME}
        getent passwd ${_NAME} >/dev/null 2>&1 || useradd -u ${_UID} -g ${_NAME} -m -s '/bin/bash' ${_NAME} \
            && usermod -p nopwd ${_NAME}
        passwd -u ${_NAME} || true
    done
fi

# Update MOTD
if [ -v MOTD ]; then
    echo -e "$MOTD" > /etc/motd
fi
