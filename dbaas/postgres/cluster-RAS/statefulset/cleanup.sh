
kubectl delete -f pg-svc.json

kubectl delete configmap consul


kubectl delete -f pg-statefulset.yaml 

kubectl delete -f consul-join.yaml

kubectl delete -f nodeJsPgApp.json

kubectl delete -f pgpool.json
