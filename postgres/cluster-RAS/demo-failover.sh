#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

run "kubectl delete pods -l role=pgmaster"
run "sleep 30"
run "kubectl get pods -l role=pgmaster"
run "kubectl get pods -l role=pgslave"
