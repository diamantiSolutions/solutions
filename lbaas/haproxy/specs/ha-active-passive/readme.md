# Highly available HAProxy in active-passive mode.

***

This example will demonstrate how to setup HAProxy in active-passive mode to provided highly available and scalable solution. This will containe two instances of HAProxy one a active and one passive. At a given time floating VIP will point to the active instance of HAProxy. In case active HAProxy instance goes down, etcd demon will switch the VIP to point to the passive HAproxy.  

## prerquisite
This example is extension of haproxy/specs/stable example. It will use ingress resource and backends from `solutions/lbaas/haproxy/specs/stable` example. So make sure the first follow and create pods based on the readme file at `../stable/readme.md`.


### 1. Deploy passive HAProxy.

  scale the haproxy  as described in `../stable/readme.md` to have 2 copy of Ingress controller
  ```
  kubectl scale deployment haproxy-ingress --replicas=2
  ```

### 2. Create configuration for etcd daemonset.
  Create a configmap for the etcd daemon by replacing the template text with your own VIP being used for this HA solutions. Make sure to use correct static IP as floating IP, which is not conflicting with others in network. We picked an unused IP from the current default network.
  ```
  sed "s/<MY_FLOATING_IP>/172.16.137.101/g"  vip-configmap.yaml | kubectl create --namespace=$ns -f -
  ```

### 3. Create etcd daemonset.
  start the keepalived DameonSet to manage and failover the VIP. 
   ```
   kubectl create -f keepalived.yaml
   ```
   
### 4. Test the setup
   test that whole setup is working as expected.
* figure out the ip of both load balancer.
* test LB1 by running following cmd for coffee svc, multiple times, every time response address  should ping pong between IP of multiple coffe svc:
   ```
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
   ```
* test LB1 by running following cmd for tea svc, multiple times, every time response address should ping pong between IP of multiple tea svc:
   ```
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
   ```
* test LB2 by running following cmd for coffee svc, multiple times, every time response address  should ping pong between IP of multiple coffee svc:
   ```
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
   ```
* test LB2 by running following cmd for tea svc, multiple times, every time response address  should ping pong between IP of multiple tea svc:
   ```
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
   ```
* double check the etcd config by looking at the keepalived config in one of 3 etcd pods. config should contain your specified address as virtual address, and two the LB IP ad real IP address with port 443.
  ```
  kubectl exec -it  kube-keepalived-vip-8qx12 cat /etc/keepalived/keepalived.conf
  ```
* you can also open the GUI of both ingress load balancer and monitor its health on browser as follows:
  ```
  http://<LB_1_IP>:8080/status.html
  http://<LB_2_IP>:8080/status.html
  ```


### 5. test for HA.

* To test properly to see if HA setup is working or not, its better to create two different deployment for ingress controller instead of scaling it. For normal setup scaling the deployment enough, this setup is just for ease in testing. 
* test if VIP is working or not by running following cmds for coffee/tea and make sure you get similar results as you would get for accessing ingress LB directly.
  ```
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
  ```
*  Now lets delete the original ingress LB to see if floating IP switches to to secondary LB
  ```
  kubectl delete deployment haproxy-ingress-1
  ```
* Now check to make sure both coffee/tea svcs are still accessible using the floating IP, while deleted ingress controller may not be available.
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"

* try deleting/creating haproxy-ingress-1 and haproxy-ingress-2 multiple times and make sure that services are continuously available via floating IP.

