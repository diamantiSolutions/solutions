kubectl create namespace registry-artifactory

#>> create postgres sql storage
kubectl apply -f postgresql-storage.yaml
kubectl apply -f postgresql.yaml

#>> create artifactory storage
kubectl apply -f artifactory-storage.yaml

#>> create deployment  services.
kubectl apply -f artifactory.yaml


echo "Waiting for  Artifactory to be up and running! (it might take up to 5+ min)"

sleep 5

ART_POD_NAME=$(kubectl get pods -n registry-artifactory -l app=artifactory-pro  | grep artifactory-deployment | cut -d' ' -f1)

while true ; do
	printf "." 
	result=$(kubectl logs ${ART_POD_NAME} -n registry-artifactory  | grep -c 'Artifactory successfully started .* seconds') # 
	if [ $result  -eq 1 ] ; then
	    echo " Artifactory is  up and running!"
	    break
	fi
	sleep 5
    done


echo "setting up nginx"

#create tls

# create secrete based on tls
kubectl create secret tls -n registry-artifactory art-tls --cert=/home/diamanti/registry-tls/jfrog-tls/registry.crt --key=/home/diamanti/registry-tls/jfrog-tls/registry.key

#copy over certificate to docker demon accessing registry, so that it trusts. 
#sudo mkdir  /etc/docker/certs.d/proxy.registry-artifactory.svc.solutions.eng.diamanti.com/
#sudo cp /home/diamanti/registry-tls/jfrog-tls/registry.crt /etc/docker/certs.d/proxy.registry-artifactory.svc.solutions.eng.diamanti.com/ca.crt


# Storage and deployment
kubectl apply -f nginx-storage.yaml
kubectl apply -f nginx-deployment.yaml

# Service
kubectl apply -f nginx-service.yaml
