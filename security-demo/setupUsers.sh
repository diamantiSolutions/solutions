dctl user group create ug0 --role-list container-edit/ns0
dctl user group create ug1 --role-list container-edit/ns1

dctl user create u0 --local-auth --group-list ug0 -p Pass1234!
dctl user create u1 --local-auth --group-list ug1 -p Pass1234!

dctl user group create network-admin-group --role-list network-edit 
dctl user create na --local-auth --group-list network-admin-group -p Pass1234!

dctl user group create storage-admin-group --role-list volume-edit
dctl user create sa --local-auth --group-list storage-admin-group -p Pass1234!

dctl user group create project-manager-group --role-list allcontainer-view,volume-view,network-view
dctl user create pm --local-auth --group-list project-manager-group  -p Pass1234!

dctl user group create cluster-manager-group --role-list allcontainer-edit,volume-edit,network-edit
dctl user create cm --local-auth --group-list cluster-manager-group -p Pass1234!


