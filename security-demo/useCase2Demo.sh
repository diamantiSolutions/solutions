#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

#Serperate projects"
run "echo \"----------------- Users Case-2: Seperate projects ------------------\""
run "dctl login -u u0 -p Pass1234!"
run "sed -e 's~<num>~0~g' app.yaml | kubectl create -f -"
run "kubectl get pods -o wide -l app=simple-app"
run "dctl logout"
run "dctl login -u u1 -p Pass1234!"
run "sed -e 's~<num>~0~g' app.yaml | kubectl create -f -"
run "kubectl get pods -o wide --all-namespaces -l app=simple-app"
run "kubectl get pods -o wide -l app=simple-app"
run "dctl logout"
run "dctl login -u pm -p Pass1234!"
run "kubectl get pods -o wide --all-namespaces -l app=simple-app"
