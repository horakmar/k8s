#!/bin/bash
set -x

echo -n >users

for i in $(ls keys); do
    for j in '' 0 1 2 3; do 
        USERID=$(ldapsearch -H ldaps://addc.cezdata.corp -b "OU=uzivatele,DC=cezdata,DC=corp" -D "USERNAME@cezdata.corp" -w "PASSWORD" "(sAMAccountName=$i$j)" uid -LLL | grep uid)
        res=$?
        if [[ $res -eq 0 ]] ; then
            echo $i$j:${USERID#uid: }:${USERID#uid: } >>users
            [[ -n "$j" ]] && mv keys/$i keys/$i$j
            break
        fi
    done
done
