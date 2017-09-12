# Example

## Prerequisites

* Kubernetes 1.2 and later (TLS support for Ingress has been added in 1.2)
* For NGINX Plus:
  * This demo is using  guptaarvindk/nginx-plus-ingress:latest, but  you need to build your own plus image with correct licence form nginx.
  * Build and make available in your cluster the [Ingress controller](../../nginx-controller) image.
  * Update the container image field in the ```nginx-plus-ingress-rc.yaml``` file accordingly.

## Running the Example

## 1. Deploy the Ingress Controller

1. Create an Ingress controller either for NGINX Plus:
  ```
  $ kubectl create -f nginx-plus-ingress-rc.yaml
  ```

1. Diamanti provided IP to each pod, so port forwarding is needed.

## 2. Deploy the Cafe Application

1. Create the coffee  service and replication controllers:

  ```
  $ kubectl create -f coffee-rc.yaml
  $ kubectl create -f coffee-svc.yaml
  ```

## 3. Configure Load Balancing

1. Create a secret with an SSL certificate and a key:
  ```
  $ kubectl create -f cafe-secret.yaml
  ```

1. Create an Ingress Resource:
  ```
  $ kubectl create -f cafe-ingress.yaml
  ```

## 4. Test the Application

1. Find out the external IP address of the node where the controller is running:
  ```
  $ kubectl get pods -o wide
    NAME                          READY     STATUS    RESTARTS   AGE       IP             NODE
    coffee-rc-9tfkg               1/1       Running   0          5m        172.16.137.6   appserv38
    nginx-plus-ingress-rc-394zp   1/1       Running   0          5m        172.16.137.4   appserv38
  ```
   Note down IP of load balancer form above output as XXX.YYY.ZZZ.III


1. To see that the controller is working, let's curl the load balancer.
We'll use ```curl```'s --insecure option to turn off certificate verification of our self-signed
certificate and the --resolve option to set the Host header of a request with ```cafe.example.com```
  To get coffee:
  ```
  $ curl --resolve cafe.example.com:443:XXX.YYY.ZZZ.III https://cafe.example.com --insecure
  <!DOCTYPE html>
  <html>
  <head>
  <title>Hello from NGINX!</title>
  <style>
      body {
          width: 35em;
          margin: 0 auto;
          font-family: Tahoma, Verdana, Arial, sans-serif;
      }
  </style>
  </head>
  <body>
  <h1>Hello!</h1>
  <h2>URI = /coffee</h2>
  <h2>My hostname is coffee-rc-mu9ns</h2>
  <h2>My address is 10.244.0.3:80</h2>
  </body>
  </html>
  ```

  1. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html
  If you go to the Upstream tab, you'll see all the backend webserver attached to load balancer.



## 4. Test the scaling

1. lets scale up the server.
  ```
  $  kubectl scale --replicas=8 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```
1. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html
  If you go to the Upstream tab, you'll see that there are 8 backend server showing up now 

1. If you curl again and again to same address as in previous step, you will see number of request will increase for each backend server in round robin fashion.

1. lets scale down the master.
  ```
  $  kubectl scale --replicas=3 -f coffee-rc.yaml
  replicationcontroller "coffee-rc" scaled
  ```
1. If you're using NGINX Plus, you can open the live activity monitoring dashboard, which is available at http://XXX.YYY.ZZZ.III:8080/status.html
  If you go to the Upstream tab, you'll see that there are 3 backend server showing up now 
 