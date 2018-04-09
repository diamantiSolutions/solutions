# Example

## Prerequisites

* Diamanti platform with Kubernetes 1.2 and later (TLS support for Ingress has been added in 1.2)


## Running the Example


## 1. Deploy the backend Applications

1.1. Create the coffee and tea service and replication controllers for backend servers:

  ```
  $ kubectl create -f coffee-configmap.yaml
  $ kubectl create -f coffee-rc.yaml
  $ kubectl create -f tea-configmap.yaml
  $ kubectl create -f tea-rc.yaml
  $ kubectl create -f default-http-backend.yaml

  ```

## 2. Deploy the Ingress Controller

3.1. Create an HAproxy Ingress controller :
  ```
  $ kubectl create -f haproxy-configmap.yaml
  $ kubectl create -f haproxy-ingress.yaml
  ```

## 3. Configure Load Balancing

3.2. Create an Ingress Resource:
  ```
  $ kubectl create -f cafe-ingress.yaml
  ```


## 4. Test the Application

4.1. Find out the external IP address of the node where the controller is running:
  ```
  $ kubectl get pods -o wide
    NAME                          READY     STATUS    RESTARTS   AGE       IP             NODE
    coffee-rc-9tfkg               1/1       Running   0          5m        172.16.137.6   node37
    tea-rc-egs6e                  1/1       Running   0          5m        172.16.137.7   node38
    haproxy-ingress-394zp         1/1       Running   0          5m        172.16.137.4   node36
  ```
   Note down IP of load balancer form above output as XXX.YYY.ZZZ.III


4.2. To see that the controller is working, let's curl the load balancer.
We'll use ```curl```'s --insecure option to turn off certificate verification of our self-signed
certificate and the --resolve option to set the Host header of a request with ```cafe.example.com```.  

  To get tea:
  ```
  $ curl --resolve cafe.example.com:XXX.YYY.ZZZ.III http://cafe.example.com/tea --insecure
  ```
  or  
  To get coffee:
  ```
  $ curl --resolve cafe.example.com:XXX.YYY.ZZZ.III http://cafe.example.com/cofffe --insecure
    <!DOCTYPE html>
    <html>
    <head>
    <title>Hello World    </title>
    ...
    <p><span>Server&nbsp;address:</span> <span>172.16.137.5:80</span></p>
    ...
    </html>

  ```
4.3. In the curl response you will see the address and name of the web server responded.



## 5. Test the scaling

5.1. lets scale up the server.
  ```
  $  kubectl scale --replicas=8 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```

5.3. If you curl again and again to haproxy load balancer IP as in previous step, In the curl response you will see the address and name of the web server will change.
```
   curl --resolve cafe.example.com:XXX.YYY.ZZZ.III http://cafe.example.com/coffee --insecure | grep address
```

5.5. lets scale down the master.
  ```
  $  kubectl scale --replicas=3 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```


## 6. setting up TLS for SSL termination


1. Create the DNS entry
```$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt```

1. Specify DNS name as common name when creating the certificate.
```Common Name (eg, your name or your server's hostname) []:*.cafe.example.com```

1. Create tls secrete:
```$ kubectl create secret tls haproxy-tls --cert=/home/diamanti/tls/cafe.example.com/registry.crt --key=/home/diamanti/tls/cafe.example.com/registry.key```


1. add tls support in ingress spec
```
spec:
  tls:
  - hosts:
    - cafe.example.com
    secretName: haproxy-tls
```

1. create new modified ingress.
```
$ kubectl create -f cafe-ingress-tls.yaml
```


1. Access the services with https. 
```
curl --resolve cafe.example.com:443:172.16.254.201 https://cafe.example.com/coffee/ -k  | grep address
curl --resolve cafe.example.com:443:172.16.254.201 https://cafe.example.com/tea/ -k  | grep address
```

> Please note as we are using self signed certificate, curl will complain about the authenticity, so for testign purpose you can run curl with `-k` or `--insecure` option



1. you can also setup a default TLS with cmdline args to HAProxy container:
```
...
      containers:
      - name: haproxy-ingress
        image: quay.io/jcmoraisjr/haproxy-ingress
        args:
        - --default-backend-service=$(POD_NAMESPACE)/default-http-backend  # here is where the default backend (the 404) is set
        - --default-ssl-certificate=$(POD_NAMESPACE)/tls-secret   # here is where the secret is used
```



## 7. North-south access to HAProxy

1. Diamanti networking lets you assign an IP address to a Pod which is directly accessible from your network. So you can simply create a DNS entry for cafe.example.com pointing to HAproxy IP. And access cafe.example.com directly.


```
$ curl http://cafe.example.com/tea/
$ curl http://cafe.example.com/coffee/
$ curl https://cafe.example.com/tea/ -k
$ curl https://cafe.example.com/coffee/ -k
```



## 7. East-west access to HAProxy

When accessing the HAProxy from within cluster, there are two options.

1. Using custom DNS name. If you need to use your own custom DNS name then either you can add an entry for it to your local DNS server just like in north-south access OR you can add it /etc/hosts of pod accessing the HAProxy.

2. Using Kubernetes DNS names. In case of east-west access custom DNS name may not have much relevance. In that case you can access the load balancer with fully qualified hostname assigned by  Kubernetes itself. This way its accessible from any pod in the cluster without any need to modify any setting anywhere. But in that case, you need to setup the Ingress configuration accordingly. Following is an example of

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: my-ns
  name: cafe-ingress
  labels:
    app: cafe-ingress
spec:
  rules:
  - host: mylb.my-ns.svc.cluster-domain.com
    http:
      paths:
      - path: /
        backend:
          serviceName: coffee-svc
          servicePort: 80
      - path: /tea
        backend:
          serviceName: tea-svc
          servicePort: 80
      - path: /coffee
        backend:
          serviceName: coffee-svc
          servicePort: 80

```


***
> you can use run*.sh scripts in this dir to do everything in one step. But be aware that it assumes you don’t have any existing pods running. So, it’s better to run the script first with delete option to cleanup.
```
./run.sh delete
./run.sh
```






