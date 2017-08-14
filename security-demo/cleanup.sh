dctl login -u admin -p diamanti 
kubectl delete -f q-app.yaml
sed -e 's~<num>~0~g' app.yaml | kubectl delete -f -
sed -e 's~<num>~1~g' app.yaml | kubectl delete -f -
sed -e 's~<num>~shared-0~g' app.yaml | kubectl delete -f -
sed -e 's~<num>~shared-1~g' app.yaml | kubectl delete -f -
sed -e 's~<num>~0~g' pv-app.yaml | kubectl delete -f -
kubectl delete -f rq.yaml --namespace shared

dctl volume delete -y pv-0
dctl volume delete -y pv-1

#kubectl delete  pv pv-0

dctl user delete -y u0
dctl user delete -y u1
dctl user delete -y sa
dctl user delete -y pm
dctl user delete -y cm
dctl user delete -y ua

dctl user group delete -y ug0
dctl user group delete -y ug1
dctl user group delete -y storage-admin-group
dctl user group delete -y project-manager-group
dctl user group delete -y cluster-manager-group
dctl user group delete -y user-admin-group

sleep 2

dctl network delete -y blue
dctl user delete -y na
dctl user group delete -y network-admin-group
