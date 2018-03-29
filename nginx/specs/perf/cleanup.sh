kubectl delete -f nginx-ingress-rc.yaml

kubectl delete -f coffee-configmap.yaml 

kubectl delete -f coffee-rc.yaml
kubectl delete -f coffee-svc.yaml

kubectl delete -f cafe-secret.yaml
kubectl delete -f cafe-ingress.yaml
