echo $phase = phase

echo runing ycsb job
cd /usr/local/bin/ycsb-0.5.0

if [ "$phase" == "load" ]; then
        cassandra-cli -h ${target_ip} -f ../setup.usertable.cql
	bin/ycsb load cassandra-10 -threads ${THREADS} -P workloads/${WORKLOAD}  -p hosts=${target_ip} -s
fi

if [ "$phase" == "run" ]; then
	bin/ycsb run cassandra-10 -threads ${THREADS} -P workloads/${WORKLOAD}  -p hosts=${target_ip} -s
fi
