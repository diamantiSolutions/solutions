# Example

## Prerequisites

* Diamanti plateform with Kubernetes 1.2 and later (TLS support for Ingress has been added in 1.2)


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
  $ curl --resolve cafe.example.com:443:XXX.YYY.ZZZ.III https://cafe.example.com/tea --insecure
  ```
  or  
  To get coffee:
  ```
  $ curl --resolve cafe.example.com:443:XXX.YYY.ZZZ.III https://cafe.example.com/cofffe --insecure
    <!DOCTYPE html>
    <html>
    <head>
    <title>Hello World    </title>
    ...
    ...
    <div class="info">
    <p><span>Server&nbsp;name:</span> <span>coffee-rc-blkhf</span></p>
    <p><span>Server&nbsp;address:</span> <span>172.16.137.5:80</span></p>
    <!--<p><span>User&nbsp;Agent:</span> <span><small>curl/7.29.0</small></span></p>-->
    <p class="smaller"><span>URI:</span> <span>/</span></p>
    <p class="smaller"><span>Date:</span> <span>12/Sep/2017:21:20:08 +0000</span></p>
    <p class="smaller"><span>Client&nbsp;IP:</span> <span>172.16.137.4:60464</span></p>
    <p class="smaller"><span>NGINX&nbsp;Front-End&nbsp;Load&nbsp;Balancer&nbsp;IP:</span> <span>172.16.137.4:60464</span></p>
    <p class="smaller"><span>Client&nbsp;IP:</span> <span>172.16.6.136</span></p>
    <p class="smaller"><span>NGINX Version:</span> <span>1.13.3</span></p>
    </div>
        <div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
        <div id="footer">
            <div id="center" align="center">
                Request ID: 83f787520176a0c76a8316ee6b71db6f<br/>
                &copy; NGINX, Inc. 2016
            </div>
       </div>
    </body>
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
   curl --resolve cafe.example.com:443:XXX.YYY.ZZZ.III https://cafe.example.com/coffee --insecure | grep address
```

5.5. lets scale down the master.
  ```
  $  kubectl scale --replicas=3 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```
