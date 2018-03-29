#!/bin/sh

kubectl delete all --all
#kubectl delete statefulset --all
#kubectl delete jobs --all
kubectl delete configmap --all
kubectl delete storageclass --all
kubectl delete pvc --all
