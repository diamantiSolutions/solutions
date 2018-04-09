#!/bin/sh  -x

if [0] ; then

if [ ! -z $WRK_RUNTIME ]; then
    WRK_RUNTIME=180s
fi

if [ ! -z $WRK_NUM_CONNECTIONS ] ; then
    WRK_NUM_CONNECTIONS=50
fi


if [ ! -z $WRK_NUM_CORE ]; then
    WRK_NUM_CORE=32
fi


if [ ! -z $NGINX_IP ]; then
	echo "NGINX_IP env var is not set, aborting"
	exit 1
fi


if [ ! -z $DOMAIN_NAME ]; then
	echo "DOMAIN_NAME env var is not set, aborting"
	exit 1
fi

if [ ! -z $TEST_URI ]; then
	echo "TEST_URI env var is not set, aborting"
	exit 1
fi

fi

echo  $NGINX_IP  $DOMAIN_NAME >> /etc/hosts
date
ip a
date
ping $DOMAIN_NAME -c 2
date
ip a
date
for i in `seq 1 $WRK_NUM_CORE`; do
    date
    ip a
    date
    taskset -c $i wrk -t 1 -c $WRK_NUM_CONNECTIONS -d $WRK_RUNTIME $TEST_URI > $i.log &
done

date
ip a
date
wait
#sleep $WRK_RUNTIME
#date
#ip a
#date
#sleep 20


for i in `seq 1 $WRK_NUM_CORE`; do
    ip a
    date
    cat $i.log
    date
done

cat

wait

exit
