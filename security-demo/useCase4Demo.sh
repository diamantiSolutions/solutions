#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

#Shared project different role"
run "echo \"----------------- Users Case-4: shared project with different role ------------------\""
run "dctl login -u u1 -p Pass1234! -n shared"
run "kubectl get pods -o wide -n ns0 -l app=simple-app"
run "dctl logout"
run "dctl login -u ua -p Pass1234!"
run "dctl user group edit ug1 --role-list container-edit/ns1,container-edit/shared,container-view/ns0,network-view"
run "dctl logout"
run "dctl login -u u1 -p Pass1234! -n ns0"
run "kubectl get pods -o wide -n ns0 -l app=simple-app"
run "sed -e 's~<num>~Error~g' app.yaml | kubectl create -f -"
#run "dctl -o json whoami"
run "dctl logout"
