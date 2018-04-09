if [ $# -eq 0 ]
then
    echo "No namespace supplied using default"
    ns=default
else
    ns=$1
fi

./cleanupPlus.sh $ns

#create load balancer pod
kubectl create -f nginx-plus-ingress-rc.yaml --namespace=$ns
#kubectl create -f nginx-lb-configmap.yaml 

#create backend web server (config,pod,svc)
kubectl create -f coffee-configmap.yaml --namespace=$ns
kubectl create -f coffee-rc.yaml --namespace=$ns
kubectl create -f coffee-svc.yaml --namespace=$ns

kubectl create -f tea-configmap.yaml --namespace=$ns
kubectl create -f tea-rc.yaml --namespace=$ns
kubectl create -f tea-svc.yaml --namespace=$ns


#sleep 60

#create ingress configuration to be used by nginx ingress controller (load balancer)
kubectl create -f cafe-secret.yaml --namespace=$ns
kubectl create -f cafe-ingress.yaml --namespace=$ns

