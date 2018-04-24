
# Deploying HAProxy across multiple availability zone on Diamanti.

***

This example will demonstrate how to setup HAProxy to serve across multiple availability zone on Diamanti.

> You can use this guide to enahance any other soltion described at haproxy/specs/* 


1. ### Create a cluster with more than one availibility zone
```
name: diamanti-cluster
spec:
 nodes:
   - node1
   - node2
   - node3
 config:
   virtualIP: 172.16.19.52
   podDnsDomain: dev.diamanti.com
   storageVlan: 475
   adminUserPassword: MyPassword1!
   zones:
         zone1: ["node1","node2"]
         zone2: ["node3"]

```

create the cluster with above yaml cfg file
```
dctl cluster create -f ???
```

2. ### Make sure thatzones are setup correctly.
make sure all nodes are automatically labled with there respective lables `failure-domain.beta.kubernetes.io/zone=<ZONE_NAME>`
```
$ kubectl get nodes --show-labels
NAME        STATUS    ROLES     AGE       VERSION   LABELS
node1   Ready     <none>    2m        v1.8.6    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=zone1,kubernetes.io/hostname=node1
node2   Ready     <none>    2m        v1.8.6    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=zone2,kubernetes.io/hostname=node2
node3   Ready     <none>    2m        v1.8.6    beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=zone1,kubernetes.io/hostname=node3
```

3. ### Create networks for all the zones.
Create one or more unique networks for each zone with one or more common netowrk group.
```
$ dctl network create blue -s 172.16.179.0/24 --start 172.16.179.4 --end 172.16.179.255 -g 172.16.179.1 -v 179 -n group1  -z zone1
$ dctl network create red -s 172.16.254.0/24 --start 172.16.254.4 --end 172.16.254.255 -g 172.16.254.1 -v 254 -n group1  -z zone2

$ dctl netowrk list
NAME      TYPE      START ADDRESS   TOTAL     USED      GATEWAY        VLAN      NETWORK-GROUP   ZONE
blue      public    172.16.179.4    250       3         172.16.179.1   179       group1          zone1
red       public    172.16.254.4    250       6         172.16.254.1   254       group1          zone2
```

4. ### Add correct network on podspec.
Diamanti scheduler will try to schedule the pods across all the zones for a given netowrk group. This spreading of pods across various availability zone depends on how network is annotated in podsepc.

* Specify the network group annotation if you need all the pods to be spread across multiple availability zone of the given group. We should do tis for all the backend server specs being served by HAProxy. In this example we need to modify tea-rc and coffe-rc pods. This will make sure they are deployed/scaled across zones.
```
spec:
  template:
    metadata:
      annotations:     
        diamanti.com/endpoint0: '{"networkGroup":"group1","perfTier":"high"}'
```

* For better visiblity and performance, more than one interfaces might be needed for Ingress controller pod. In that case it can be either assigned from network group or directly from a specific netowrk depending on which zone we want the Ingress controller pod to be running at.
```
        diamanti.com/endpoint0: '{"networkGroup":"group1","perfTier":"high"}'
        diamanti.com/endpoint1: '{"network":"blue","perfTier":"high"}'
```

* In some cases it might be useful to assign  static endpoint to Ingress controller interfaces for north-south access and DNS mapping.
```
        diamanti.com/endpoint0: '{"endpointId":"haproxy-ep-1","perfTier":"high"}'
        diamanti.com/endpoint1: '{"endpointId":"haproxy-ep-2","perfTier":"high"}'
```
above static endpoint can be create as follows:
```
dctl endpoint create ????

dctl endpoint create haproxy-ep-1 -i 172.16.254.201 -n red
dctl endpoint create haproxy-ep-2 -i 172.16.254.202 -n red
```
