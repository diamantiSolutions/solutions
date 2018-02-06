#kubectl create ns docker-registry
#dctl volume create vol-registry -s 50G -m 3
kubectl create -f registry.yaml
