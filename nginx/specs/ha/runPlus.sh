#for non only use namespace default, other namespace wont work.
if [ $# -eq 0 ]
then
    echo "No namespace supplied using default"
    ns=default
else
    ns=$1
fi


MY_FLOATING_IP=172.16.137.251

#crerate nginx primary laod balancer and 2 tea/2coffe services behind it.
./cleanupPlus.sh $ns
cd ../stable
../stable/runPlus.sh $ns
cd ../ha

#create secondry standby load balancer pod
sed "s/<yourOwnNginxPlusIngressImage:version>/guptaarvindk\/nginx-plus-ingress:latest/g" nginx-plus-ingress-rc-1.yaml | kubectl create  --namespace=$ns -f -


#setup floating IP
# set correct configmap by replacing the IP address in foollowing file with the one IP addressess avaialble in your network
#vip-configmap.yaml

sed "s/<MY_FLOATING_IP>/$MY_FLOATING_IP/g"  vip-configmap.yaml | kubectl create --namespace=$ns -f -

kubectl create -f vip-daemonset.yaml --namespace=$ns
