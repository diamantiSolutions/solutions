#/bin/bash
dctl network list | grep sql
dctl volume list | grep sql
dctl network create sqlnet -s 172.16.21.0/24 --start 172.16.21.10 --end 172.16.21.250 -g 172.16.21.1 -v 21
dctl volume create mssql-1 -s 100Gi
kubectl create -f mssql-persistent.yaml
sleep 7
kubectl get ep mssql-1
