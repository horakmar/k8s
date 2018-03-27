#!/bin/sh

LOG_LEVEL=${LOGLEVEL:-2}
export LOG_LEVEL

[ $LOG_LEVEL -gt 3 ] && set -x

cp /etc/hostname /usr/share/nginx/html/

for i in $(ls /etc/nginx/conf.d/*.conf); do
    sed -i "s/{{server_name}}/$SERVER_NAME/g" $i
done

exec "$@"
