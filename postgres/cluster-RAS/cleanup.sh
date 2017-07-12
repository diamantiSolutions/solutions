
kubectl delete -f pg-svc.json

kubectl delete configmap consul

sed -e 's~<num>~0~g' postgres-pod.json | kubectl delete -f -
sed -e 's~<num>~1~g' postgres-pod.json | kubectl delete -f -
sed -e 's~<num>~2~g' postgres-pod.json | kubectl delete -f -

kubectl delete -f consul-join.yaml

kubectl delete -f nodeJsPgApp.json

kubectl delete -f pgpool.json
