#!/bin/sh
kubectl apply -f k8s/deployment.yaml 
kubectl apply -f k8s/service.yaml 
#kubectl apply -f k8s/deployment.yaml --validate=false
#kubectl apply -f k8s/service.yaml --validate=false

