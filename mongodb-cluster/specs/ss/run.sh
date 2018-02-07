#!/bin/bash
#date "+%H:%M:%S"

MY_NAME=${1:-"demo"}

./cleanup.sh $MY_NAME 
sleep 20

kubectl create -f diamanti-m3-high.yaml  
sed  -e "s/SVC_NAME/$MY_NAME/g" mongo-statefulset.yaml | kubectl create -f -

sleep 80

#sed  -e "s/TARGET/$MY_NAME-rs-0.$MY_NAME-mongo,$MY_NAME-rs-1.$MY_NAME-mongo,$MY_NAME-rs-2.$MY_NAME-mongo/g"  mongo-bench.json | kubectl create -f -

