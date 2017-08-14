echo "> dctl volume create pg-vol-0 -s 20G -m 3"
dctl volume create pg-vol-0 -s 20G -m 3 
echo "> dctl volume create pg-vol-1 -s 20G -m 3"
dctl volume create pg-vol-1 -s 20G -m 3 
echo "> dctl volume create pg-vol-2 -s 20G -m 3"
dctl volume create pg-vol-2 -s 20G -m 3 

echo "> dctl volume create consul-vol-0 -s 5G -m 3"
dctl volume create consul-vol-0 -s 5G -m 3
echo "> dctl volume create consul-vol-1 -s 5G -m 3"
dctl volume create consul-vol-1 -s 5G -m 3
echo "> dctl volume create consul-vol-2 -s 5G -m 3"
dctl volume create consul-vol-2 -s 5G -m 3

echo "> dctl volume list"
dctl volume list

