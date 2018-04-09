#!/bin/sh

echo "modifying /etc/host"
echo  $NGINX_IP  $DOMAIN_NAME >> /etc/hosts
date >> run.log
ip a >> run.log
echo "starting wrk test"
wrk -t 1 -c $WRK_NUM_CONNECTIONS -d $WRK_RUNTIME $TEST_URI

echo "finished wrk test"
date >> run.log
ip a >> run.log

#doing below to make sure container keep running while we look at the log, also making sure network is not gone by calling ping.
while true; do
    sleep 10
    echo "in sleep loop" >> run.log
    date >> run.log
    ip a >> run.log
    ping $DOMAIN_NAME -c 1  >> run.log
done


exit
