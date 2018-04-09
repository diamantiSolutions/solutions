# Example

## Prerequisites

* Please note that currenlty this example only works when using namespace default.
* Diamanti plateform with Kubernetes 1.2 and later (TLS support for Ingress has been added in 1.2)
* For NGINX Plus:
  * Youu need to build your own plus image by copying correct license keys (obtained form nginx) to kubernetes-ingress/nginx-controller dir.
  ```
  cd kubernetes-ingress/nginx-controller;
  make clean;
  make container DOCKERFILE=DockerfileForPlus
  docker tag nginxdemos/nginx-ingress:0.8.1 <yourDockerImage:version>
  docker push  <yourDockerImage:version>
  ```
  * Update the container image field in the ```nginx-plus-ingress-rc.yaml``` file accordingly.


## Running the Example

## 1. Deploy the Ingress Controller

1.1. Create an Ingress controller either for NGINX or NGINX Plus:
  ```
  $ kubectl create -f nginx-ingress-rc.yaml
  ```
  or
  ```
  $ kubectl create -f nginx-plus-ingress-rc.yaml
  ```

1.2. Diamanti provided IP to each pod, so port forwarding is not needed.

## 2. Deploy the Cafe Application

2.1. Create the coffee and tea service and replication controllers:

  ```
  $ kubectl create -f coffee-configmap.yaml 
  $ kubectl create -f coffee-rc.yaml
  $ kubectl create -f coffee-svc.yaml
  $ kubectl create -f tea-configmap.yaml 
  $ kubectl create -f tea-rc.yaml
  $ kubectl create -f tea-svc.yaml
  ```

## 3. Configure Load Balancing

3.1. Create a secret with an SSL certificate and a key:
  ```
  $ kubectl create -f cafe-secret.yaml
  ```

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
    nginx-plus-ingress-rc-394zp   1/1       Running   0          5m        172.16.137.4   node36
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

4.4. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html.  If you go to the Upstream tab, you'll see all the backend webserver attached to load balancer.



## 5. Test the scaling

5.1. lets scale up the server.
  ```
  $  kubectl scale --replicas=8 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```
5.2. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html  
  If you go to the Upstream tab, you'll see that there are 8 backend server showing up now 

5.3. If you curl again and again to nginx load balancer IP as in previous step, In the curl response you will see the address and name of the web server will change.
```
   curl --resolve cafe.example.com:443:XXX.YYY.ZZZ.III https://cafe.example.com/coffee --insecure | grep address
```
5.4. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html. You will see number of request will increase for each backend server in round robin fashion.

5.5. lets scale down the master.
  ```
  $  kubectl scale --replicas=3 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```
5.6. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html.   If you go to the Upstream tab, you'll see that there are 3 backend server showing up now 
 