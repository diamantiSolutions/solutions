
mode=${1:-"create"}

kubectl $mode -f coffee-configmap.yaml
kubectl $mode -f coffee-rc.yaml
kubectl $mode -f tea-configmap.yaml
kubectl $mode -f tea-rc.yaml
kubectl $mode -f default-http-backend.yaml


kubectl $mode -f haproxy-configmap.yaml
kubectl $mode -f haproxy-ingress.yaml
kubectl $mode -f cafe-ingress.yaml
