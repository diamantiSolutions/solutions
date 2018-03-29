
# Deploying Aquasec on Diamanti


1.0. Aquasec need to provide you access to there docker image, once you ahve have access, create a pull secrete for dockerhub where you have access to aquasec image.
```
kubectl create secret docker-registry dockerhub --docker-username=<uname> --docker-password=<pwd> --docker-email=<email> -n aquasec
```

2.0. Setup secrete password for aquasec databases
```
kubectl create secret generic aqua-db --from-literal=password=<New_pwd> -n aquasec
```

3.0. Create s service account with access to dockerpull secrete created earlier.
```
kubectl create -f sa.yaml
```

4.0. Deploy all the aquasec related pods and services. Following cmd will create
 - Persistent volume claim for aquasec database
 - Service for aquasec database
 - Aquasec database
 - Service for aquasec gateway
 - Aquasec gateway pod
 - Service for aquasec web console  pod
 - Aquasec web console pod
```
kubectl create -f aqua-server-diamanti.yaml
```


5.0. Deploy aqua agents as demonset 

kubectl create -f aqua-agent.yaml


6.0. Find the IP of aquasec web console
```
kubectl get pods -o wide -n aquasec
NAME                            READY     STATUS    RESTARTS   AGE       IP              NODE
aqua-agent-46v92                1/1       Running   0          4m        172.20.0.223    appserv95
aqua-agent-8jrwg                1/1       Running   0          4m        172.20.0.170    appserv94
aqua-agent-mqp67                1/1       Running   0          4m        172.20.0.186    appserv96
aqua-db-57dc954789-pplpk        1/1       Running   0          9m        172.16.138.55   appserv95
aqua-gateway-7ccf647cfd-wrkmq   1/1       Running   0          9m        172.16.138.53   appserv95
aqua-web-698d48998d-dtn9t       1/1       Running   0          9m        172.16.138.54   appserv95
```
6.1. Access the aquasec webserver a follows:
```
http://<AQUASEC_WEB_IP>:8080
```
6.2. Setup admin Paaswword and enter the license key. Aquase is ready for use.


