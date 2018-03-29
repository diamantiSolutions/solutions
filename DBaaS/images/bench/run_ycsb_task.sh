
echo executing make_db.prop.sh
./make_db.prop.sh > /tmp/db.properties

if [ "$phase" == "load" ]; then

    echo creating ycsb database

    if [ "${DB}" = "memsql" ]; then
        #mysqladmin -h $target_ip -u root --force drop ycsb
        mysqladmin -h $target_ip -u root create ycsb
        mysql -h $target_ip -u root --database ycsb < setup.usertable.sql
    fi

    if [ "${DB}" = "mysql" ]; then 
        #mysqladmin -h $target_ip -u root --password=admin --force drop ycsb 
        mysqladmin -h $target_ip -u root --password=admin create ycsb
        mysql -h $target_ip -u root --password=admin --database ycsb < setup.usertable.sql
    fi

    if [ "${DB}" = "postgres" ]; then
        export PGPASSWORD=admin
        #psql  -h $target_ip -c 'drop database IF EXISTS ycsb' -U pgbench
        psql  -h $target_ip -c 'create database ycsb' -U pgbench
        psql -h $target_ip -U pgbench -d ycsb < setup.usertable.sql
    fi
fi

echo $phase = phase
echo runing ycsb job
cd /usr/local/bin/ycsb-0.5.0

if [ "$phase" == "load" ]; then
    if [ "${DB}" = "postgres" ]; then
	bin/ycsb load jdbc -cp . -threads ${THREADS} -P workloads/workloaddwsmysql -P /tmp/db.properties -cp /usr/share/java/postgresql-9.4.1212.jar -s 
    else
	bin/ycsb load jdbc -cp . -threads ${THREADS} -P workloads/workloaddwsmysql -P /tmp/db.properties -cp /usr/share/java/mysql-connector-java.jar -s 
    fi
fi

if [ "$phase" == "run" ]; then
    if [ "${DB}" = "postgres" ]; then
	bin/ycsb run jdbc -cp . -threads ${THREADS} -P workloads/workloaddwsmysql -P /tmp/db.properties -cp /usr/share/java/postgresql-9.4.1212.jar -s 
    else
	bin/ycsb run jdbc -cp . -threads ${THREADS} -P workloads/workloaddwsmysql -P /tmp/db.properties -cp /usr/share/java/mysql-connector-java.jar -s 
    fi
fi
