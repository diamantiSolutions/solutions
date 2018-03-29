kubectl delete -f wrk2.yaml

kubectl delete -f nginx-lb-configmap.yaml 

kubectl delete -f nginx-plus-ingress-rc.yaml

kubectl delete -f nginx-configmap.yaml 

kubectl delete -f tea-rc.yaml
kubectl delete -f tea-svc.yaml
kubectl delete -f coffee-rc.yaml
kubectl delete -f coffee-svc.yaml

kubectl delete -f cafe-secret.yaml
kubectl delete -f cafe-ingress.yaml
