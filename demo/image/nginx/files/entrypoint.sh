#!/bin/sh

LOG_LEVEL=${LOGLEVEL:-2}
export LOG_LEVEL

[ $LOG_LEVEL -gt 3 ] && set -x

ln -sf /etc/hostname /usr/share/nginx/html/index.html
sed -i "s/{{server_name}}/$SERVER_NAME/g" /etc/nginx/conf.d/default.conf
sed -i "s/{{server_name}}/$SERVER_NAME/g" /etc/nginx/conf.d/ssl.conf

exec "$@"
