

kubectl delete -f nginx-plus-ingress-rc.yaml --namespace=$1

kubectl delete -f coffee-configmap.yaml --namespace=$1

kubectl delete -f coffee-rc.yaml --namespace=$1
kubectl delete -f coffee-svc.yaml --namespace=$1

kubectl delete -f tea-configmap.yaml  --namespace=$1

kubectl delete -f tea-rc.yaml --namespace=$1
kubectl delete -f tea-svc.yaml --namespace=$1


kubectl delete -f cafe-secret.yaml --namespace=$1
kubectl delete -f cafe-ingress.yaml --namespace=$1
