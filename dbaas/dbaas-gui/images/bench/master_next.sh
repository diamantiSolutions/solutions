#!/bin/bash
echo executing master_next.sh

threads=16
#if [ "$phase" == "load" ]; then
#    threads=50
#fi

#if [ "${DB}" = "memsql" || "${DB}" = "postgres" ]; then
    if [ "${QOS}" = "high" ]; then
        threads= 32
    elif [ "${QOS}" = "medium" ]; then
        threads=16
    else
        threads=8
    fi
#fi

if [ "${DB}" = "mysql" ]; then threads=$((threads/2)); fi
if [ "${DB}" = "mysql" ]; then threads=$((threads/4)); fi

export THREADS=${threads:-16}
nginx_next() {
    echo executing nginx_next
    while [ true ]; do
	curl -s  http://$target_ip/master.txt > /dev/null;
    done
}

mysql_next() {

        echo running sysbench test
        ./run_mysql_task.sh

}

memsql_next() {

        echo running sysbench test
        ./run_memsql_task.sh

}

postgres_next() {

	echo running pgbench test
	./run_pgbench_task.sh


}

master_next() {

	echo running ycsb test
	./run_ycsb_task.sh
}

mongo_next() {
	echo executing mongo_next

	export WRITE_CONCERN=${WRITE_CONCERN:-1}
	export WORKLOAD=${WORKLOAD:-workloadLong5050}

	echo running ycsb test
	./run_ycsb_mongo_task.sh

	echo end mongo_next
}

cassandra_next() {
        echo executing cassandra_next

        export WORKLOAD=${WORKLOAD:-workloadcas5050}

        echo running ycsb test
        ./run_ycsb_cassandra_task.sh

        echo end cassandra_next
}

if [ "${DB}" = "mongo" ]; then
	mongo_next
elif [ "${DB}" = "cassandra" ]; then
        cassandra_next
elif [ "${DB}" = "nginx" ]; then
        nginx_next
elif [ "${DB}" = "postgres" ]; then
        postgres_next
#elif [ "${DB}" = "mysql" ]; then
#        mysql_next
elif [ "${DB}" = "memsql" ]; then
        memsql_next
else
	master_next
fi

echo end master_next
