
./cleanup.sh

sleep 1

kubectl create configmap consul --from-file=consul-server-configmap.json



kubectl create -f pg-svc.json 

sed -e 's~<num>~0~g' postgres-pod.json | kubectl create -f -
sed -e 's~<num>~1~g' postgres-pod.json | kubectl create -f -
sed -e 's~<num>~2~g' postgres-pod.json | kubectl create -f -


sleep 60

kubectl create -f consul-join.yaml 

kubectl create -f pgpool.json

kubectl create -f nodeJsPgApp.json 
