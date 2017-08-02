./cleanup.sh
dctl volume delete pg-vol-0 -y 
dctl volume delete pg-vol-1 -y
dctl volume delete pg-vol-2 -y

dctl volume delete consul-vol-0 -y 
dctl volume delete consul-vol-1 -y
dctl volume delete consul-vol-2 -y
