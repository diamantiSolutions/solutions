# Highly available HAProxy in active-active mode.

***

This example will demonstrate how to setup HAProxy to setup in active-active mode to provided highly available and scalable solution, while making sure that if one HAProxy goes down user’s session still persists.

This solution requires HA-proxy configuration to be modified to enable stick table for session persistence. We also need let each HAProxy know the list of peers of the HA cluster they part of. As current HAProxy ingress controller configmap doesn’t support these configurations, we have forked the HAProxy to extend the capability. We will try to roll the changes back to upstream HAProxy. Meanwhile current HAProxy fork is available at:

```
HAProxy URL
```


> This example is extension of haproxy/specs/stable example. It will use ingress resource and backends from haproxy/specs/stable example. 


1. As HAProxy doesn’t have peers discover mechanism, we need to create static endpoints (IP) for each HAproxy. This is also useful for North-South access of Ingress controller. You will need to specify the network to use, as well as an IP from the range of the network. 
```
dctl endpoint create haproxy-ep-1 -i 172.16.254.201 -n red
dctl endpoint create haproxy-ep-2 -i 172.16.254.202 -n red
```

1. Modify the specs to use Diamanti's HAProxy image for ingress controller. Also in order to setup the Peers its advisable to use a static hostname in your cfg file, otherwise whenever container restarts with new hostname Peers wont work.
```
...
spec:
 template:
    ...
    spec:
      hostname: haproxy-<NUM>
```


> Here NUM is your HAproxy instance number.


1. Add following to HAProxy configmap to setup the peers and stick table correctly, please note following will `ONLY` work with Diamanti version of HAProxy.
```
data:
  ...
  balance-algorithm: roundrobin
  haproxy-peers-cfg: |
    peers diamanti_peers
        peer haproxy-1 <STATIC_IP>:1024
        peer haproxy-2 <STATIC_IP>:1024

  stick-table-cfg: |
    stick-table type ip size 20k peers diamanti_peers
        stick on src


````

1. Create backend servers
```
kubectl create -f ../stable/coffee-configmap.yaml
kubectl create -f ../stable/coffee-rc.yaml
kubectl create -f ../stable/tea-configmap.yaml
kubectl create -f ../stable/tea-rc.yaml
kubectl create -f ../stable/default-http-backend.yaml
```


1. Create HAProxy configmap containing the peer configuration.
```
kubectl create -f haproxy-configmap.yaml
```

1. Create HAProxy instance
```
kubectl create -f haproxy-ingress-1.yaml
kubectl create -f haproxy-ingress-1.yaml
```

1. Create Ingress resource
```
kubectl create -f ../stable/cafe-ingress.yaml
```


1. In order to test the setup. Curl the tea or coffee services via all HAProxy instance from many different machines in your network. For a given client machine, all the requests to a given svc should be returned by same server IP. In this example you can grep for address field in response.

```
[diamanti@server1 ~]$ curl --resolve cafe.example.com:172.16.254.201 http://cafe.example.com/coffee/ -k  | grep address

<p><span>Server&nbsp;address:</span> <span>172.16.254.4:80</span></p>

[diamanti@server2 ~]$ curl --resolve cafe.example.com:172.16.254.201 http://cafe.example.com/coffee/ -k  | grep address

<p><span>Server&nbsp;address:</span> <span>172.16.254.4:80</span></p>

[diamanti@server1 ~]$ curl --resolve cafe.example.com:172.16.254.201 http://cafe.example.com/tea/ -k  | grep address

<p><span>Server&nbsp;address:</span> <span>172.16.254.7:80</span></p>

[diamanti@server2 ~]$ curl --resolve cafe.example.com:172.16.254.201 http://cafe.example.com/tea/ -k  | grep address

<p><span>Server&nbsp;address:</span> <span>172.16.254.7:80</span></p>
```



1. If you prefer to use official HAProxy image you can manually modify the haproxy.cfg by getting in to the pod and modify the /etc/haproxy/haproxy.cfg and reload HAProxy. Please note that this step is not needed if you are using Diamanti HAProxy image.
* get into pods
```
$ kubectl exec -it <HAProxy Pod> sh
```

* modify /etc/haproxy/haproxy.cfg
```
$ vi /etc/haproxy/haproxy.cfg
```
* Add following inside each backend block in haproxy.cfg.
```
    stick-table type ip size 20k peers diamanti_peers
    stick on src
```
* Add following at the top level of haproxy.cfg
```
peers diamanti_peers
    peer <HAPROXY_INSTANCE_1_HOSTNAME>  <HAPROXY_INSTANCE_1_IP>:1024
    peer <HAPROXY_INSTANCE_1_HOSTNAME>  <HAPROXY_INSTANCE_1_IP>:1024
```
* reload the HAProxy instance inside the container
```
./haproxy-reload.sh native /etc/haproxy/haproxy.cfg
```
