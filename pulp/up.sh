#!/usr/bin/env bash

# starts Pulp services

kubectl apply -f resources/celerybeat.yaml
kubectl apply -f resources/httpd.yaml
kubectl apply -f resources/worker.yaml
kubectl apply -f resources/resource_manager.yaml
