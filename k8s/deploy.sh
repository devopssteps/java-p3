#!/bin/sh
kubectl apply -f k8s/deployment.yml --validate=false
kubectl apply -f k8s/service.yml --validate=false
