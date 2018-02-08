# DOCKER REGISTRY setup on Diamanti (HA)


##setup namespace
1.0. We will be running registry on seperate namespace to keep isolation.
```
kubectl create ns docker-registry
```
## Setup persistant storage.
2.0. Docker registry can be setup with either dynamic or static persistant storage, but in this example we will use static storage, as static storage are easier to track and identify that it belongs to registry.
2.2. Create a static persistant storage for the registry. In order to provide the High availbility of the registry we will use 3 way mirrored volume so that registry will continue to be availble even in case of node or pod failure.
```
dctl volume create vol-registry -s 50G -m 3
```
alternatively a persistant volumeclaim can be added to spec so that static volume is not needed.

2.3. deploy the registry.
```
kubectl create -f registry-ha.yaml 
```
you will notice that we are only running 1 replica of registry deployment but still calling it HA.  HA is provided by the mirrored volume, which is mirrored across 3 nodes. In case node or pod dies, deplymnet will restart the pod in any other available node (where mirrored volume exists) within seconds. So within seconds registry will be back up and running without losing any data. Time taken in recreatign the registry pod depends on evection and other timouts configured. 

## Running insecure registry (not reccomonded) 

3.0. docker by defualt uses https, so it will fail when trying to access insecure registry. To make it work with defualt insecure  regsitry restart docker with:
* add following in " /etc/docker/daemon.json "
  ```
   { "insecure-registries":["registry.docker-registry.svc.<cluster_domain (eg. solutions.diamanti.com)>:5000"] }
   ```
* restart docker:
  ```
   sudo service docker restart
   ```
* above need to be done for each docker daemon (ie each node) who is going to access the registry.


3.1.  Accessing registry:
```
sudo docker tag guptaarvindk/nginx-web:perf registry.docker-registry.svc.solutions.diamanti.com:5000/nginx-web:perf
sudo docker push registry.docker-registry.svc.solutions.diamanti.com:5000/nginx-web:perf
sudo docker pull registry.docker-registry.svc.solutions.diamanti.com:5000/nginx-web:perf
```

3.2 Generally its not reccomonded to use registry in insecure mode. But it really depends on individual use cases. If your setup is withing the firewall and on the local network itself with small userbase then insucure might be ok.


## Running partial secure REGISTRY with self-signed certs.

4.1. create self signed cert. Make sure to enter the "registry.docker-registry.svc.<cluster_domain (eg. solutions.diamanti.com)>" as common nsmae while creating the certificates. :

```
cd /home/diamanti/registry-tls/
openssl req  -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt
```

4.2. Please note that you will need to manually copy above certificates to docker dir of any host accessing the registry:
```
sudo cp registry.crt  /etc/docker/certs.d/registry.docker-registry.svc.solutions.diamanti.com/ca.crt
```

4.3. use certificate to create a config map containing certficate, we will utelize this config map as a volume in our registry 
```
cd /home/diamanti/
kubectl create configmap docker-registry-tls --from-file=registry-tls/ -n docker-registry
```
verify:
```
 kubectl get configmaps docker-registry-tls -o yaml -n docker-registry
```

4.4. delete inscure registry deployment and create secure deployment 
```
kubectl delete -f registry-ha.yaml 
kubectl create -f registry-ha-tls.yaml 
```

4.5 Start accessing secure registry:
```
sudo docker tag guptaarvindk/nginx-web:perf registry.docker-registry.svc.solutions.diamanti.com/nginx-web:perf
sudo docker push registry.docker-registry.svc.solutions.diamanti.com/nginx-web:perf
sudo docker pull registry.docker-registry.svc.solutions.diamanti.com/nginx-web:perf
```

Note that we dont need port number in case of secure registry as we are running https on default post.


