#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh


#Cluster role, volume managmemnt"
run "echo \"----------------- Users Case-5: Cluster role: Volume management ------------------\""
run "dctl login -u u1 -p Pass1234! -n ns0"
run "dctl volume create pv-0 -s 10G"
run "dctl volume list"
run "dctl logout"
run "dctl login -u sa -p Pass1234!"
run "dctl volume create pv-0 -s 10G"
run "dctl logout"
run "dctl login -u u1 -p Pass1234! -n ns1"
run "sed -e 's~<num>~0~g' pv-app.yaml | kubectl create -f -"
run "kubectl get pods -o wide -l app=simple-app"
run "dctl logout"
