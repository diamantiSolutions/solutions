#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

#run "dctl cluster status"
run "sudo systemctl restart convoy"
run "cd /dwshome/agupta/work/solutions/github/simpleApp"
run "dctl logout"
run "clear"
run "dctl login -u admin"
run "clear"
run "dctl user role list"
#Create users"
run "echo \"----------------- Users in enterprise ------------------\""
run "dctl user group create user-admin-group --role-list user-edit"
run "dctl user create ua --local-auth --group-list user-admin-group -p Pass1234!"
run "dctl logout"
run "dctl login -u ua -p Pass1234!"
run "dctl user group create ug0 --role-list container-edit/ns0"
run "dctl user group create ug1 --role-list container-edit/ns1"
run "dctl user create u0 --local-auth --group-list ug0 -p Pass1234!"
run "dctl user create u1 --local-auth --group-list ug1 -p Pass1234!"
run "dctl user group create network-admin-group --role-list network-edit "
run "dctl user create na --local-auth --group-list network-admin-group -p Pass1234!"
run "dctl user group create storage-admin-group --role-list volume-edit"
run "dctl user create sa --local-auth --group-list storage-admin-group -p Pass1234!"
run "dctl user group create project-manager-group --role-list allcontainer-view,volume-view,network-view,node-view,perftier-view,user-view"
run "dctl user create pm --local-auth --group-list project-manager-group  -p Pass1234!"
run "dctl user group create cluster-manager-group --role-list allcontainer-edit,volume-edit,network-edit"
run "dctl user create cm --local-auth --group-list cluster-manager-group -p Pass1234!"
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
#Network-admin"
run "echo \"----------------- Users Case-1: Network admin ------------------\""
run "dctl login -u u1 -p Pass1234!"
run "dctl network create blue -s 172.16.157.0/24 --start 172.16.157.4 --end 172.16.157.253 -g 172.16.157.1 -v 157"
run "dctl logout"
run "dctl login -u na -p Pass1234!"
run "dctl network create blue -s 172.16.157.0/24 --start 172.16.157.4 --end 172.16.157.253 -g 172.16.157.1 -v 157"
run "dctl logout"
run "dctl login -u ua -p Pass1234!"
run "dctl user group edit ug0 --role-list container-edit/ns0,network-view"
run "dctl user group edit ug1 --role-list container-edit/ns1,network-view"
run "dctl logout"
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
#SHOW GUI for each users"
#run "echo \"----------------- Lets look at GUI to see what we have done so far ------------------\""
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
#Cluster role and cluster role binding."
run "echo \"----------------- Users Case-6: Cluster role: others  ------------------\""
run "dctl login -u cm -p Pass1234!"
run "kubectl get pods -o wide --all-namespaces"
run "kubectl delete pods simple-vol-app -n ns1"
run "kubectl delete pvc pvc-0 -n ns1"
run "dctl volume delete -y pv-0"
run "dctl logout"
#Ressource  quota"
run "echo \"----------------- Users Case-7: resource quota ------------------\""
run "dctl login -u admin "
run "cat rq.yaml"
run "kubectl create -f rq.yaml --namespace shared"
run "dctl logout"
run "dctl login -u u1 -p Pass1234! -n shared"
run "cat q-app.yaml"
run "kubectl create -f q-app.yaml"
run ""
