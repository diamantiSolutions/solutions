
kubectl delete -f quay-namespace.yaml

while true ; do
	printf "." 
	result=$(kubectl get ns quay-enterprise 2>/dev/null  | grep -c 'STATUS') # 
	if [ $result  -eq 0 ] ; then
	    echo ""
	    echo " namespace quay-enterprise is deleted!"
	    break
	fi
	sleep 1
    done
