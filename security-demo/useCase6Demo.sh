#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh


run "echo \"----------------- Users Case-6: Cluster role: others  ------------------\""
run "dctl login -u cm -p Pass1234!"
run "kubectl get pods -o wide --all-namespaces"
run "kubectl delete pods simple-vol-app -n ns1"
run "kubectl delete pvc pvc-0 -n ns1"
run "dctl volume delete -y pv-0"
run "dctl logout"
