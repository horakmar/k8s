#!/bin/bash
#
# Print service account token
#
if [ -z "$1" ] ; then
    cat <<EOF
Usage:
    $0 <user>

EOF
else
    tokename=$(kubectl get serviceaccount admin-user -o jsonpath='{.secrets[0].name}')
    token=$(kubectl -n kube-system get secret $tokename -o jsonpath='{.data.token}' | base64 -d)
    echo -e "$tokename:\n$token"
fi
