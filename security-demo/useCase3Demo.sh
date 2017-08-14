#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

#Shared project"
run "echo \"----------------- Users Case-3: Shared projects ------------------\""
run "dctl logout"
run "dctl login -u ua -p Pass1234!"
run "dctl user group edit ug0 --role-list container-edit/ns0,container-edit/shared,network-view"
run "dctl user group edit ug1 --role-list container-edit/ns1,container-edit/shared,network-view"
run "dctl logout"
run "dctl login -u u0 -p Pass1234! -n shared"
run "sed -e 's~<num>~shared-0~g' app.yaml | kubectl create -f -"
run "dctl logout"
run "dctl login -u u1 -p Pass1234! -n shared"
run "sed -e 's~<num>~shared-0~g' app.yaml | kubectl create -f -"
run "sed -e 's~<num>~shared-1~g' app.yaml | kubectl create -f -"
run "kubectl get pods -o wide"
run "dctl logout"
run "dctl login -u pm -p Pass1234!"
run "kubectl get pods -o wide --all-namespaces -l app=simple-app"
run "dctl logout"
