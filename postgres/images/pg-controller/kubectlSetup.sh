#curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#chmod +x ./kubectl

PWD=`pwd`
export PATH=$PATH:$PWD

#setup Kubernetes
kubectl config set-cluster $KUBERNETES_CLUSTER_NAME --server=http://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
kubectl config set-context pgcontext --cluster=$KUBERNETES_CLUSTER_NAME
kubectl config use-context pgcontext
