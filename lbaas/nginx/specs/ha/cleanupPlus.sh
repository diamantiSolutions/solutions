
kubectl delete -f nginx-plus-ingress-rc-1.yaml --namespace=$1

kubectl delete -f vip-configmap.yaml  --namespace=$1

kubectl delete -f vip-daemonset.yaml  --namespace=$1

