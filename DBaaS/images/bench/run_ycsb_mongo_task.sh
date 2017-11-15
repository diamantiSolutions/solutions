echo $phase = phase

echo runing ycsb job
#cd /usr/local/bin/ycsb-0.5.0
cd ycsb-0.5.0
#if [ "$phase" == "load" ]; then
        #compact="db.usertable.remove({});printjson(db.runCommand({'compact':'usertable','force':true}));"
        #mongo --eval "${compact}" ${target_ip}:27017/ycsb >> /dev/null 2>&1
	bin/ycsb load -cp . mongodb -threads ${THREADS} -P workloads/${WORKLOAD}  -p mongodb.url=mongodb://${target_ip}:27017/ycsb?w=${WRITE_CONCERN} -s -p debug=false
#fi

#if [ "$phase" == "run" ]; then
	bin/ycsb run -cp . mongodb -threads ${THREADS} -P workloads/${WORKLOAD} -p mongodb.url=mongodb://${target_ip}:27017/ycsb?w=${WRITE_CONCERN} -s -p debug=false
#fi
