
kubectl create -f quay-namespace.yaml


#create volume/pvc and create PV if necessory.
dctl volume create registry-quay-vol -s 110G -m 2
sleep 5
kubectl create -f quay-storage.yaml



# RBAC, secretes and configs
kubectl create -f quay-servicetoken-role.yaml
kubectl create -f quay-servicetoken-role-binding.yaml
#obtain auth token from tectonics account and setup the in the config.json
kubectl create secret generic coreos-pull-secret --from-file=".dockerconfigjson=config.json" --type='kubernetes.io/dockerconfigjson' --namespace=quay-enterprise
kubectl create -f quay-config-secret.yaml


#create databases (mysql/pg and redis)
kubectl create -f quay-mysql.yaml
kubectl create -f quay-redis.yaml


#deploy Quay application
kubectl create -f quay-app-rc.yaml
kubectl create -f quay-service.yaml


