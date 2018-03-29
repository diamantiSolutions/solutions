kubectl create ns registry-nexus
dctl volume create vol-nexus-registry -s 50G -m 3
kubectl create secret tls nexus-tls -n registry-nexus  --cert=/home/diamanti/registry-tls/nexus-tls/registry.crt --key=/home/diamanti/registry-tls/nexus-tls/registry.key
kubectl create -f nexus.yaml
