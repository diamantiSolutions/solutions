#!/bin/bash
date "+%H:%M:%S"
./cleanup.sh
date "+%H:%M:%S"
sleep 4
date "+%H:%M:%S"
sed -e 's~<num>~0~g' mongo-node-template.yaml | kubectl create -f -
sed -e 's~<num>~1~g' mongo-node-template.yaml | kubectl create -f -
sed -e 's~<num>~2~g' mongo-node-template.yaml | kubectl create -f -
date "+%H:%M:%S"
sleep 4
date "+%H:%M:%S"
kubectl create -f nodeJsMongoApp.yaml
date "+%H:%M:%S"

