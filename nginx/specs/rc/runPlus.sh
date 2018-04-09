./cleanupPlus.sh

kubectl create -f nginx-lb-configmap.yaml 
kubectl create -f nginx-plus-ingress-rc.yaml


kubectl create -f nginx-configmap.yaml 
kubectl create -f tea-rc.yaml
kubectl create -f tea-svc.yaml
kubectl create -f coffee-rc.yaml
kubectl create -f coffee-svc.yaml
sleep 60
kubectl create -f cafe-secret.yaml
kubectl create -f cafe-ingress.yaml 
