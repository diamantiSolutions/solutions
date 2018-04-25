
./cleanup.sh

sleep 1

kubectl create configmap consul --from-file=consul-server-configmap.json



kubectl create -f pg-svc.json 

kubectl create -f pg-statefulset.yaml 

sleep 60

#kubectl create -f consul-join.yaml 

kubectl create -f pgpool.json

kubectl create -f nodeJsPgApp.json 
