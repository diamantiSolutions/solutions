./cleanup.sh
sleep 10
./volDelete.sh
sleep 10
dctl volume create vol-pg-ha-master -s 20g
dctl volume create vol-pg-ha-slave-1 -s 20g
dctl volume create vol-pg-ha-slave-2 -s 20g
