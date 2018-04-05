#!/bin/bash

echo "Login to cluster"
dctl -s 172.16.17.3 login -u admin -p Pass1234!

echo "Clean up potentially old instances of this"
kubectl delete namespace nginx-ingress

echo "Wait for namespace deletion"
sleep 60

echo "Create the services"
kubectl create -f common/ns-and-sa.yaml
kubectl create -f common/nginx-config.yaml
kubectl create -f common/default-server-secret.yaml
kubectl create -f rbac/rbac.yaml
kubectl create -f deployment/nginx-ingress.yaml
kubectl create -f service/loadbalancer.yaml
kubectl create -f complete-example/cafe.yaml
kubectl create -f complete-example/cafe-ingress.yaml
kubectl create -f complete-example/cafe-secret.yaml
echo "Wait for everything to fire up"
sleep 60
#kubectl create -f stress/wrk-rc.yaml

# ssh diamanti@appserv94 "\$HOME/wrk-4.1.0/wrk -c 50 -t 50 -d 60 https://nginx-ingress.nginx-ingress.svc.solutions.eng.diamanti.com/tea"
# sysctl net.core.optmem_max=25165824
# sysctl net.core.netdev_max_backlog=65536
# sysctl net.core.wmem_max=33554432
# sysctl net.core.wmem_default=31457280
# sysctl net.core.rmem_max=33554432
# sysctl net.core.rmem_default=31457280
# sysctl vm.dirty_background_ratio=2
# sysctl vm.dirty_ratio=60
# sysctl net.core.somaxconn=65535
