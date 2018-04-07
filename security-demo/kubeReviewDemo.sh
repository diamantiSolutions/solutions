#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

run "echo \"----------------- Users mapped to Kuberenetes ------------------\""
run "dctl login -u admin"
run "dctl user group list"
run "dctl user list"
run "kubectl get namespaces"
run "kubectl get rolebindings --all-namespaces"
run "kubectl get clusterrolebindings"
run "kubectl -o yaml get namespace/ns0"
run "kubectl -o yaml get rolebinding/diamanti.com:ug0 --namespace=ns0"
run "kubectl -o yaml get clusterrolebinding/diamanti.com:cluster-manager-group"
run "dctl logout"
