#!/usr/bin/env bash

kubectl delete secret pulp-config
kubectl delete secret pulp-httpd-certs
kubectl delete secret pulp-mongodb-cert
kubectl delete secret pulp-client-cert
kubectl delete secret pulp-qpiddb
kubectl delete configmap pulp-ca
