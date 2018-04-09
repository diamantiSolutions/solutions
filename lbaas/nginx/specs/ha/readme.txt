

#1 edit runPlus.sh to specify the correct static IP as  floatign IP. I picked an unsed IP from my current default network.
* we need to figureout if we can reserve some IP or use different network so that its not assigned to any other pod lateron. 
MY_FLOATING_IP=172.16.137.251

#2 deploy:
- create Primary ingres controller with 4 backend services (two coffee svc, two tea svc)
- create standby ingress controller
- create etcd configmap with correct floatign IP
- create etcd dameonset.

./runPlus.sh


#3 test that whole setup is working as expected.
- figureout the ip of both load balancer.
- test LB1 by running following cmd for coffee svc, multipl times, everytime response address  should ping pong between IP of multiple coffe svc:
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
- test LB1 by running following cmd for tea svc, multipl times, everytime response address  should ping pong between IP of multiple tea svc:
   curl --resolve cafe.example.com:443:<LB_1_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
- test LB2 by running following cmd for coffee svc, multipl times, everytime response address  should ping pong between IP of multiple coffe svc:
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
- test LB2 by running following cmd for tea svc, multipl times, everytime response address  should ping pong between IP of multiple tea svc:
   curl --resolve cafe.example.com:443:<LB_2_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
- doublec check the etcd config by looking at the keepalived config in one of 3 etcd pods. config should contain your specified address as virtual address, and two the LB IP ad real IP address with port 443.
  kubectl exec -it  kube-keepalived-vip-8qx12 cat /etc/keepalived/keepalived.conf
- you can also open the gui of both ingress load balancer and montior its health on broweser as follows:
  http://<LB_1_IP>:8080/status.html
  http://<LB_2_IP>:8080/status.html



#4 test for HA.
- test if VIP is working or not by running follwign cmds for coffe/tea and make sure you get similar results as you would get for accessing ingress LB directly.
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"
- Now lets delete the original ingress LB to see if floating IP switches to to secondary LB
  kubectl delete rc nginx-plus-ingress-rc1

- Now check to make sure both coffee/tea svcs are still accessible using the floating IP, while delete RC ingress may not be avaialbe..
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/tea --insecure | grep "Server&nbsp;address"
  curl --resolve cafe.example.com:443:<MY_FLOATING_IP> https://cafe.example.com/coffee --insecure | grep "Server&nbsp;address"

-try delteting/creating nginx-plus-ingress-rc and nginx-plus-ingress-rc1 multipl times and make sure that services are continuously avaialble via floating IP.

