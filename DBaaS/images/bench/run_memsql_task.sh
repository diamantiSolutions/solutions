echo $phase = phase
echo runing memsql-sysbench job

if [ "$phase" == "load" ]; then
    #mysqladmin -h $target_ip -u root --force drop ycsb
    mysqladmin -h $target_ip -u root create ycsb
    sysbench --db-driver=mysql --test=oltp --oltp-table-size=300000000 --batch --batch-delay=10  --mysql-user=root  --mysql-password="" --mysql-db=ycsb --mysql-host=$target_ip --mysql-port=3306  prepare
else
    sysbench --db-driver=mysql --test=oltp --oltp-table-size=300000000 --batch --batch-delay=10  --mysql-user=root  --mysql-password="" --mysql-db=ycsb --mysql-host=$target_ip --mysql-port=3306  --max-time=30000 --num-threads=${THREADS} --oltp-dist-pct=50 --max-requests=0 run 
fi

