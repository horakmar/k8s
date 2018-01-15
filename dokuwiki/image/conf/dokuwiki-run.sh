#!/bin/sh

#echo "Starting environment..."
#if [ $INSTALL == 0 ]; then
#  rm -f /data/dokuwiki/install.php
#fi

# run application
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
