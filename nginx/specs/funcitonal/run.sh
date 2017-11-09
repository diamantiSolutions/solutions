if [ $# -eq 0 ]
then
    echo "No namespace supplied using default"
else
    ns=$1
fi

./cleanup.sh $ns

#create load balancer pod
kubectl create -f nginx-ingress-rc.yaml

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



