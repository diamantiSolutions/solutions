
mode=${1:-"create"}

kubectl $mode -f ../stable/coffee-configmap.yaml
kubectl $mode -f ../stable/coffee-rc.yaml
kubectl $mode -f ../stable/tea-configmap.yaml
kubectl $mode -f ../stable/tea-rc.yaml
kubectl $mode -f ../stable/default-http-backend.yaml


kubectl $mode -f haproxy-configmap.yaml
kubectl $mode -f haproxy-ingress-1.yaml
kubectl $mode -f haproxy-ingress-1.yaml
kubectl $mode -f ../stable/cafe-ingress.yaml
