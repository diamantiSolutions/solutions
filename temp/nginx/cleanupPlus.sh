#!/bin/bash 



if false; then

kubectl delete all -l app=wrk
kubectl delete all -l app=nginx-plus-ingress
kubectl delete all -l app=coffee
kubectl delete ingress -l app=cafe-ingress



echo "Waiting for  all wrk pods to be deleted!"
while true ; do 
    printf "."
    result=$(kubectl get all -l app=wrk | grep -c 'READY') # -n shows line number
    if [ $result -eq 0 ] ; then
	echo "==> all wrk pods deleted!"
	break
    fi
    sleep 1
done



echo "Waiting for  all lb pods to be deleted!"
while true ; do 
    printf "."
    result=$(kubectl get all -l app=nginx-plus-ingress | grep -c 'READY') # -n shows line number
    if [ $result  -eq 0 ] ; then
	echo "==> all lb pods deleted!"
	break
    fi
    sleep 1
done



echo "Waiting for  all webserver pods to be deleted!"
while true ; do
    printf "." 
    result=$(kubectl get all -l app=coffee | grep -c 'READY') # -n shows line number
    if [ $result  -eq 0 ] ; then
	echo "all web server pods deleted!"
	break
    fi
    sleep 1
done


echo "Waiting for  all ingress pods to be deleted!"
while true ; do
    printf "."
    result=$(kubectl get all -l app=cafe-ingress | grep -c 'READY') # -n shows line number
    if [ $result  -eq 0 ] ; then
	echo "==> all ingress pods deleted!"
	break
    fi
    sleep 1
done

else


    

    #ns=$(kubectl get namespace | grep -c 'nginx-')
    
    #for (( number=1; number <= $ns; ++number ))
    #do
    #	kubectl delete namespace nginx-$number
#	kubectl delete clusterroles nginx-$number
#	kubectl delete clusterrolebindings nginx-$number
#	kubectl delete ingress -l app=cafe-ingress
 #   done


    kubectl delete namespace nginx-lb
    kubectl delete clusterroles nginx-lb
    kubectl delete clusterrolebindings nginx-lb

    echo "Waiting for  nginx-lb namespace to be deleted!"
    while true ; do
	printf "." 
	result=$(kubectl get namespace | grep -c 'nginx-lb') # -n shows line number
	if [ $result  -eq 0 ] ; then
	    echo " "
	    echo "nginx-lb namespace deleted!"
	    break
	fi
	sleep 1
    done



fi
