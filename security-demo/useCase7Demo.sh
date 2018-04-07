#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

run "echo \"----------------- Users Case-7: resource quota ------------------\""
run "dctl login -u admin "
run "cat rq.yaml"
run "kubectl create -f rq.yaml --namespace shared"
run "dctl logout"
run "dctl login -u u1 -p Pass1234! -n shared"
run "cat q-app.yaml"
run "kubectl create -f q-app.yaml"
run ""
