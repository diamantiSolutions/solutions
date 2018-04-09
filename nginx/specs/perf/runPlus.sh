./cleanupPlus.sh

#create load balancer pod
kubectl create -f nginx-plus-ingress-rc.yaml

#create backend web server (config,pod,svc)
kubectl create -f coffee-configmap.yaml 
kubectl create -f coffee-rc.yaml
kubectl create -f coffee-svc.yaml

sleep 60

#create ingress configuration to be used by nginx ingress controller (load balancer)
kubectl create -f cafe-secret.yaml
kubectl create -f cafe-ingress.yaml 
