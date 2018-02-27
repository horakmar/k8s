#!/bin/bash -e

[ "$DEBUG" == 'true' ] && set -x

# Fix permissions, if writable
if [ -w ~/.ssh ]; then
    chown root:root ~/.ssh && chmod 700 ~/.ssh/
fi
if [ -w ~/.ssh/authorized_keys ]; then
    chown root:root ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi
if [ -w /etc/ssh/authkeys ]; then
    chown root:root /etc/ssh/authkeys
    chmod 755 /etc/ssh/authkeys
    find /etc/ssh/authkeys/ -type f -exec chmod 644 {} \;
fi

mkdir -p /var/run/sshd

# Add users if SSH_USERS=user:uid:gid set
if [ -n "${SSH_USERS}" ]; then
    USERS=$(echo $SSH_USERS | tr "," "\n")
else
    USERS=''
fi
for U in $(cat /etc/ssh/users) $USERS; do
    IFS=':' read -ra UA <<< "$U"
    _NAME=${UA[0]}
    _UID=${UA[1]}
    _GID=${UA[2]}

    echo ">> Adding user ${_NAME} with uid: ${_UID}, gid: ${_GID}."
    if [ ! -e "/etc/ssh/authkeys/${_NAME}" ]; then
        echo "WARNING: No SSH authorized_keys found for ${_NAME}!"
    fi
    getent group ${_NAME} >/dev/null 2>&1 || groupadd --gid ${_GID} ${_NAME}
    getent passwd ${_NAME} >/dev/null 2>&1 || useradd -m --uid ${_UID} --gid ${_GID} --shell /bin/bash ${_NAME}
    passwd -u ${_NAME} || true
done

# Update MOTD
if [ -v MOTD ]; then
    echo -e "$MOTD" > /etc/motd
fi

sed -i '/AuthorizedKeysFile/ s/.*/AuthorizedKeysFile \/etc\/ssh\/authkeys\/%u/' /etc/ssh/sshd_config

exec "$@"
