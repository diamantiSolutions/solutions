kubectl create namespace aquasec
kubectl create secret docker-registry dockerhub --docker-username=<DOCKER_USER_NAME> --docker-password=<DOCKER_PWD> --docker-email=<DOCKER_EMAIL> -n aquasec
kubectl create secret generic aqua-db --from-literal=password=<DB_PWD> -n aquasec
kubectl create -f sa.yaml
kubectl create -f aqua-server-diamanti.yaml
sleep 30
kubectl create -f aqua-agent-diamanti.yaml
