#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

run "kubectl get po,rc,svc"
run "kubectl create configmap consul --from-file=consul-server-configmap.json"
run "kubectl create -f pg-svc.json "
run "sed -e 's~<num>~0~g' postgres-pod.json | kubectl create -f -"
run "sed -e 's~<num>~1~g' postgres-pod.json | kubectl create -f -"
run "sed -e 's~<num>~2~g' postgres-pod.json | kubectl create -f -"
run "kubectl create -f nodeJsPgApp.json "
run "sleep 30"
run "kubectl create -f consul-join.yaml"
run "sleep 5"
run "kubectl create -f pgpool.json"
run "sleep 5"
run "kubectl get pods -l role=pgmaster"
run "kubectl get pods -l role=pgslave"
run "kubectl get po,rc,svc"
