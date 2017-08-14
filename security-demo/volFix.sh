dctl login -u admin -p diamanti 
kubectl create clusterrolebinding diamanti.com:storage-admin-binding --clusterrole=system:persistent-volume-provisioner --group=storage-admin-group
sed -e 's~<num>~0~g' pv.yaml | kubectl create -f -
