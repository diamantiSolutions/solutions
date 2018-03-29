


# Deploying Nexus Docker Registry on Diamanti


##setup namespace
1.0. We will be running registry on separate namespace to keep isolation from other project.
```
kubectl create ns registry-nexus
```

## Setup persistant storage.
2.0. Docker registry can be setup with either dynamic or static persistant storage, but in this example we will use static storage, as static storage are easier to track and identify that it belongs to registry.
2.2. Create a static persistant storage for the registry. In order to provide the High availbility of the registry we will use 3 way mirrored volume so that registry will continue to be availble even in case of node or pod failure.
```
dctl volume create vol-nexus-registry -s 50G -m 3
```
2.3 Please note, even though above is the way to use the persistant storage, due to a bug in nexus docker image, persistant storage not working. There support team is ntofied and waiting for there response. Meanwhile we are not using persitant storage in this example.


3.0. create tls secrete for nginx reverse proxy:
```
kubectl create secret tls nexus-tls -n registry-nexus  --cert=/home/diamanti/registry-tls/nexus-tls/registry.crt --key=/home/diamanti/registry-tls/nexus-tls/registry.key
```

4.0. setup nexus registry which also include the nginx reverse proxy for SSL termination
```
kubectl create -f nexus.yaml
```


5.0. find IP of the pod
```
$ kubectl get pods -o wide -n registry-nexus
NAME                               READY     STATUS    RESTARTS   AGE       IP             NODE
nexus-deployment-fd7c8b785-gf4tj   2/2       Running   0          4m        172.16.137.8   appserv96
```

6.0. access nexus dashboard:
```
http://<nexus_pod_ip>:8081
```

by defualt it comes with user admin and password admin123. GO ahead and change the id and password and create the docker registry named docker fromt eh setting tab.

7.0. Accessing registry:
```
$ kubectl create -f ../test/docker-testpod.yaml
pod "docker-dind" created

$  kubectl exec -it docker-dind -c docker   sh
/ # docker login proxy.registry-nexus.svc.solutions.eng.diamanti.com
Username: admin
Password:
Login Succeeded
/ # docker tag busybox:latest proxy.registry-nexus.svc.solutions.eng.diamanti.com/docker/busybox:latest
/ # docker push proxy.registry-nexus.svc.solutions.eng.diamanti.com/docker/busybox:latest
```

