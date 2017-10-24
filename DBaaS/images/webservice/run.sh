#!/bin/sh
#mkdir abc
#cd abc
#rm abc.txt

#echo "1- Script execution is stated  ">>abc.txt
#echo "2- Database is being created ">>abc.txt
#echo "3- execution is complete">>abc.txt

echo "test script response";
./kubectl get pods -o wide
perl /opt/dbaas/createDb.pl -t=postgres -n=dbaas-pg-21 -r=3 -s=20 -m=3 -sp=high -net=default -np=high -pgmasterpassword=password -pguser=pgbench -pguserpassword=password -pgdb=pgbench -pgrootpassword=password -bench 
