#!/bin/bash

./cleanup.sh

sleep 20

sed -e 's~<mode>~master~g' postgres-pod.json | kubectl create -f -
sed -e 's~<mode>~slave~g' postgres-pod.json | kubectl create -f -


kubectl create -f nodeJsPgApp.yaml
kubectl create -f nodeJsPgAppMaster.yaml  
kubectl create -f nodeJsPgAppSlave.yaml  

sleep 60
envsubst < pgpool.json  | kubectl create -f -
envsubst < watch-pod.json | kubectl create -f -
