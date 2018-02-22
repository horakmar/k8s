#!/bin/bash
set -eu

ssh -o StrictHostKeyChecking=no -o CheckHostIP=no -i /etc/keys/dokuwiki/cmd.key cmd@dokuwiki1 sudo fsfreeze --freeze /data

rbd --user kube snap create kube/kubernetes-dynamic-pvc-dd093f87-f884-11e7-9556-00237d3511d2@s1

ssh -o StrictHostKeyChecking=no -o CheckHostIP=no -i /etc/keys/dokuwiki/cmd.key cmd@dokuwiki1 sudo fsfreeze --unfreeze /data

# Pod must have hostNetwork = true, otherwise map blocks
rbd --user kube map kube/dokuwiki.backup

kctl="kubectl --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt --token=$(cat /run/secrets/kubernetes.io/serviceaccount/token) --server=https://kubernetes.default.svc"
pv=$($kctl get pvc doku-data -o jsonpath='{.spec.volumeName}')
volume=$($kctl get pv $pv -o jsonpath='{.spec.rbd.image}')



