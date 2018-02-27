#!/bin/bash
set -eu

echo -n >users

for i in $(ls keys); do
    USERID=$(ldapsearch -H ldaps://addc.cezdata.corp -b "OU=uzivatele,DC=cezdata,DC=corp" -D "qpzabbix@cezdata.corp" -w "izeer3pohS2Og@" "(sAMAccountName=$i)" uid -LLL | grep uid)
    echo $i:${USERID#uid: }:${USERID#uid: } >>users
done
