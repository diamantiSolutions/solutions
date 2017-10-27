echo $phase = phase
echo runing pgbench job

export PGPASSWORD=admin
if [ "$phase" == "load" ]; then
        #psql  -h $target_ip -c 'drop database IF EXISTS ycsb' -U pgbench
        psql  -h $target_ip -c 'create database ycsb' -U pgbench
        pgbench -h $target_ip -U pgbench -s 600 -i ycsb
else
        pgbench -h $target_ip -U pgbench -j 2 -T 30000 -c ${THREADS} ycsb -S
fi
