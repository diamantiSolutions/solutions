#!/bin/bash
#date "+%H:%M:%S"

MY_NAME=$1

kubectl delete -f diamanti-m3-high.yaml  
sed  -e "s/SVC_NAME/$MY_NAME/g" mongo-statefulset.yaml | kubectl delete -f -
sed  -e "s/SVC_NAME/$MY_NAME/g"  -e "s/TARGET/$MY_NAME-rs-0.$MY_NAME-mongo,$MY_NAME-rs-1.$MY_NAME-mongo,$MY_NAME-rs-2.$MY_NAME-mongo/g"  mongo-bench.json | kubectl delete -f -
