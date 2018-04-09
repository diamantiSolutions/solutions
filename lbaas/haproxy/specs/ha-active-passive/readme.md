

1. scale the haproxy  as described in ../stable/readme.md to have 2 copy of Ingress controller
  ```
  kubectl scale deployment haproxy-ingress --replicas=2
  ```

2. Create a configmap for the etcd daemon by replacing the template text with your own VIP being used for this HA solutions. Make sure to use correct static IP as floating IP, which is not conflicting with others in network. We picked an unused IP from the current default network.
  ```
  sed "s/<MY_FLOATING_IP>/172.16.137.101/g"  vip-configmap.yaml | kubectl create --namespace=$ns -f -
  ```

3. start the keepalived DameonSet to manage and failover the VIP. 
   ```
   kubectl create -f keepalived.yaml
   ```
   
4. test that whole setup is working as expected.
4.1  figure out the ip of both load balancer.
4.2 test LB1 by running following cmd for coffee svc, multiple times, every time response address  should ping pong between IP of multiple coffe svc:
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
4.3 test LB1 by running following cmd for tea svc, multiple times, every time response address should ping pong between IP of multiple tea svc:
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
4.4 test LB2 by running following cmd for coffee svc, multiple times, every time response address  should ping pong between IP of multiple coffee svc:
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
4.5 test LB2 by running following cmd for tea svc, multiple times, every time response address  should ping pong between IP of multiple tea svc:
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
4.6 double check the etcd config by looking at the keepalived config in one of 3 etcd pods. config should contain your specified address as virtual address, and two the LB IP ad real IP address with port 443.
  ```
  kubectl exec -it  kube-keepalived-vip-8qx12 cat /etc/keepalived/keepalived.conf
  ```
4.7 you can also open the GUI of both ingress load balancer and monitor its health on browser as follows:
  ```
  http://<LB_1_IP>:8080/status.html
  http://<LB_2_IP>:8080/status.html
  ```


5. test for HA.

5.1 To test properly to see if HA setup is working or not, its better to create two different deployment for ingress controller instead of scaling it. For normal setup scaling the deployment enough, this setup is just for ease in testing. 
5.2 test if VIP is working or not by running following cmds for coffee/tea and make sure you get similar results as you would get for accessing ingress LB directly.
  ```
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
  ```
5.3  Now lets delete the original ingress LB to see if floating IP switches to to secondary LB
  ```
  kubectl delete deployment haproxy-ingress-1
  ```
5.4 Now check to make sure both coffee/tea svcs are still accessible using the floating IP, while deleted ingress controller may not be available.
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"

5.5 try deleting/creating haproxy-ingress-1 and haproxy-ingress-2 multiple times and make sure that services are continuously available via floating IP.

