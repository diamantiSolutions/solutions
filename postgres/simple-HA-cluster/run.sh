#!/bin/bash

./cleanup.sh

sleep 20

sed -e 's~<num>~master~g' postgres-pod.json | sed -e 's~<mode>~master~g' - | kubectl create -f -
sed -e 's~<num>~slave~g' postgres-pod.json | sed -e 's~<mode>~slave~g' - |  kubectl create -f -

kubectl create -f nodeJsPgApp.yaml
kubectl create -f nodeJsPgAppMaster.yaml  
kubectl create -f nodeJsPgAppSlave.yaml  

sleep 60
envsubst < pgpool.json  | kubectl create -f -
envsubst < watch-pod.json | kubectl create -f -
