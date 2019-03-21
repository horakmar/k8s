#!/bin/bash
#
# Make certificate request and prepare to sign it
#

set -e

if [ -z "$1" ]; then
  echo "Choose cert name from:"
  ls *.json | sed "s/\.json//"
else
  server=$1
  if [ -f $server.json ] ; then
    cfssl genkey $server.json | cfssljson --bare $server
    cat $server.csr
    echo "Sign CSR at CEZ CA: https://winppkisub.cezdata.corp/certsrv/"
    echo "Then save certificat as $server.crt"
  else
    echo "File $server.json not found."
  fi
fi
