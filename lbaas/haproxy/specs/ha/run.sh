
mode=${1:-"create"}

kubectl scale deployment haproxy-ingress --replicas=2

sed "s/<MY_FLOATING_IP>/172.16.137.101/g" kubectl $mode -f vip-configmap.yaml
kubectl $mode -f keepalived.yaml
