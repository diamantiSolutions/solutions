./cleanup.sh


kubectl create -f nginx-ingress-rc.yaml

kubectl create -f tea-rc.yaml
kubectl create -f tea-svc.yaml
kubectl create -f coffee-rc.yaml
kubectl create -f coffee-svc.yaml

kubectl create -f cafe-secret.yaml
kubectl create -f cafe-ingress.yaml 
