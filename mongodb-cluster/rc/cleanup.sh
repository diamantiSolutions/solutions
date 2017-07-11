#!/bin/bash

kubectl delete svc mongo-svc-0
kubectl delete svc mongo-svc-1
kubectl delete svc mongo-svc-2
kubectl delete rc mongo-0
kubectl delete rc mongo-1
kubectl delete rc mongo-2

kubectl delete -f nodeJsMongoApp.yaml
