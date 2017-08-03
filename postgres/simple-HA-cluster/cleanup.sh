#!/bin/bash


sed -e 's~<num>~master~g' postgres-pod.json | kubectl delete -f -
sed -e 's~<num>~slave~g' postgres-pod.json | kubectl delete -f -


kubectl delete -f nodeJsPgApp.yaml
kubectl delete -f nodeJsPgAppMaster.yaml  
kubectl delete -f nodeJsPgAppSlave.yaml  
envsubst < pgpool.json  | kubectl delete -f -
envsubst < watch-pod.json | kubectl delete -f -
