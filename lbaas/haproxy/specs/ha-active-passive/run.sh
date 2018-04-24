
mode=${1:-"create"}

kubectl scale deployment haproxy-ingress --replicas=2

sed "s/<MY_FLOATING_IP>/172.16.179.251/g" vip-configmap.yaml |kubectl create -f -
kubectl $mode -f keepalived.yaml
