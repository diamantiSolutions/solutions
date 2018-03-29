
# Deploying Quay Docker Registry on Diamanti


## Note
This is not fully verified example yet. So it is not advisable to use this example.


##setup namespace
1.0. We will be running registry on separate namespace to keep isolation from other project.
```
kubectl create -f quay-namespace.yaml
```


2.0. Create Quay storage. To make this solutions Highly avaialble we are setting up storage with mirrorcount 2.
```
dctl volume create registry-quay-vol -s 110G -m 2
```
2.1. Claim the volume. Previous cmd will automatically create the PV as well, but in case you are migrating the volume or recovering previous cluster restart, you might need to re-attach it by recreating the PV.
```
kubectl create -f quay-storage.yaml
```

3.0.  Setup RBAC and secrets
kubectl create -f quay-servicetoken-role.yaml
kubectl create -f quay-servicetoken-role-binding.yaml
kubectl create -f quay-config-secret.yaml

3.1. obtain auth token from tectonics account and setup that in the config.json
kubectl create secret generic coreos-pull-secret --from-file=".dockerconfigjson=config.json" --type='kubernetes.io/dockerconfigjson' --namespace=quay-enterprise


4.0. setup databases
```
kubectl create -f quay-mysql.yaml
kubectl create -f quay-redis.yaml
```



5.0. Deployment quay registry  and services.
```
kubectl create -f quay-app-rc.yaml
kubectl create -f quay-service.yaml

```

6.0. Access quay dashboard. Find the IP of quay-enterprise-app
```
$ kubectl get pods -o wide
NAME                                     READY     STATUS             RESTARTS   AGE       IP              NODE
quay-enterprise-app-5c9888d44d-z5lmc     1/1       Running            0          21m       172.16.137.11   appserv94
quay-enterprise-redis-6f475796f5-jzjgm   1/1       Running            0          21m       172.16.137.10   appserv95
quay-mysql-674d4b85bf-gkzs2              1/1       Running            0          21m       172.16.137.12   appserv96
``

7.0. Quay setup

7.1. Go tot following URL on your browser, with IP obtained in previous step.
http://<QUAY_APP_IP>/setup/

7.2. Setup will ask for license key, enter it from tectonics account.
7.3. Setup will ask for database setup, enter info from mssql/pg pod.
7.4. quay contiainer will restart, wait on GUI.
7.5.  quay will ask for account setup.
super user:
user: admin
password: ****
(agupta@diamanti.com) 

7.6. it will promt for all the settings, enter the redis informtion and save. It will restart the container again to install the changes.

7.7.  after that it will bring to superuser panel to manage registries etc.

7.8. setup TLS as described in:
https://coreos.com/quay-enterprise/docs/latest/quay-ssl.html



you can start pulling and pushing the registry with admin account:

9.0. Accessing repository
```
$ kubectl create -f ../test/docker-testpod.yaml
pod "docker-dind" created

[diamanti@appserv94 ~]$  kubectl exec -it docker-dind -c docker sh

/ # docker pull busybox:latest

/ # docker tag busybox:latest quay-enterprise.quay-enterprise.svc.solutions.eng.diamanti.com/docker/busybox:latest


/ # docker login quay-enterprise.quay-enterprise.svc.solutions.eng.diamanti.com
Username: admin
Password:
Login Succeeded

/ # docker push  quay-enterprise.quay-enterprise.svc.solutions.eng.diamanti.com/docker/busybox:latest
The push refers to repository [quay-enterprise.quay-enterprise.svc.solutions.eng.diamanti.com/docker/busybox]
c5183829c43c: Pushed
latest: digest: sha256:c7b0a24019b0e6eda714ec0fa137ad42bc44a754d9cea17d14fba3a80ccc1ee4 size: 527
/ #


```

