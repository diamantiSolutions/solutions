#!/bin/sh


rc=$1
reduce="-rs"

svc=$(echo "$rc" | sed "s@$reduce@@" )


kubectl delete statefulset $svc-rs &> /dev/null
kubectl delete jobs $svc-consul-join  &> /dev/null
kubectl delete rc $svc-pgpool &> /dev/null
kubectl delete svc $svc &> /dev/null
kubectl delete svc $svc-pg &> /dev/null
kubectl delete svc $svc-slave &> /dev/null
kubectl delete svc $svc-master &> /dev/null
kubectl delete svc $svc-pgbench &> /dev/null

kubectl delete pods $svc-rs-0 &> /dev/null
kubectl delete pods $svc-rs-1 &> /dev/null
kubectl delete pods $svc-rs-2 &> /dev/null
kubectl delete pods $svc-rs-3 &> /dev/null
kubectl delete pods $svc-rs-4 &> /dev/null

kubectl delete pods $svc-pgbench &> /dev/null

kubectl delete pvc pg-vol-$svc-rs-0 &> /dev/null
kubectl delete pvc pg-vol-$svc-rs-1 &> /dev/null
kubectl delete pvc pg-vol-$svc-rs-2 &> /dev/null
kubectl delete pvc pg-vol-$svc-rs-3 &> /dev/null
kubectl delete pvc pg-vol-$svc-rs-4 &> /dev/null

kubectl delete pvc mongo-vol-$svc-rs-0 &> /dev/null
kubectl delete pvc mongo-vol-$svc-rs-1 &> /dev/null
kubectl delete pvc mongo-vol-$svc-rs-2 &> /dev/null
kubectl delete pvc mongo-vol-$svc-rs-3 &> /dev/null
kubectl delete pvc mongo-vol-$svc-rs-4 &> /dev/null


kubectl delete pvc mssql-vol-$svc-rs-0 &> /dev/null
kubectl delete pvc mssql-vol-$svc-rs-1 &> /dev/null
kubectl delete pvc mssql-vol-$svc-rs-2 &> /dev/null
kubectl delete pvc mssql-vol-$svc-rs-3 &> /dev/null
kubectl delete pvc mssql-vol-$svc-rs-4 &> /dev/null


echo "deleted database svc $svc"
