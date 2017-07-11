./cleanup.sh
dctl volume delete pg-vol-0
dctl volume delete pg-vol-1
dctl volume delete pg-vol-2
dctl volume create pg-vol-0 -s 20G -m 2
dctl volume create pg-vol-1 -s 20G -m 2
dctl volume create pg-vol-2 -s 20G -m 2
