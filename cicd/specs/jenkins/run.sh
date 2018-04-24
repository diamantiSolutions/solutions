#create a user api/Diamanti1! in aqua dashboard.

#cleanup
kubectl delete -f jenkins-ns.yaml

#wait for it to get cleanedup
#sleep 15

echo "Waiting for jenkins namespace to be deleted!"
while true ; do
printf "."
result=$(kubectl get namespace | grep -c 'jenkins') # -n shows line number
if [ $result  -eq 0 ] ; then
    echo " "
    echo "jenkins namespace deleted!"
    break
fi
sleep 1
  done

#create a jenkins namespace"
kubectl create -f jenkins-ns.yaml
# "enter jenkins namespace"
dctl namespace set jenkins
# "create jenkins service account so jenkins-master can create/delete slaves"
kubectl create -f jenkins-sa.yaml

#desc "create a pvc for pv"
kubectl create -f jenkins-master-pvc.yaml

#desc "create jenkins server and service "
kubectl create -f jenkins-master-deployment.yaml
