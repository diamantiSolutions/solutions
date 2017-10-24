#!/bin/bash  -x




#461  cat masters9.txt | while read line; do ./crun.sh $line run rw > results/run-rw/$line.txt 2>&1 & done
#462  cat masters9l.txt | while read line; do ./crun.sh $line run rw > results/run-rw/$line.txt 2>&1 & done

#root@appserv33:/results/load


# $1 is the HOSTNAME
# $2 is the PG PORT
# $3 is the PG USER
#
# initialize the pgbench database
#


if [ ! -v PGHOST ]; then
	echo "PGHOST env var is not set, aborting"
	exit 1
fi

if [ ! -v PGPORT ]; then
    PGPORT=5432;
fi




if [ ! -v PG_MODE ]; then
	PG_MODE="ro";
fi

if [ ! -v SCALE_FACTOR ]; then
    SCALE_FACTOR=600;
fi
if [ ! -v ITERATIONS ]; then
    ITERATIONS=1;
fi
if [ ! -v NUM_CLIENTS ]; then
    NUM_CLIENTS=16;
fi
if [ ! -v NUM_JOBS ]; then
    NUM_JOBS=2;
fi
if [ ! -v TIME_DURATION ]; then
    TIME_DURATION=300;
fi
if [ ! -v PGBENCH_DATABASE ]; then
    PGBENCH_DATABASE=pgbench;
fi
if [ ! -v PGBENCH_USER ]; then
    PGBENCH_USER=pgbench;
fi
if [ ! -v PGBENCH_PASSWORD ]; then
    PGBENCH_PASSWORD=password;
fi

if [ ! -v NOLOAD ]; then
    NOLOAD="false"
fi


     #export PGHOST=${PGBENCH_HOST}
#export PGHOST=$1
#export PGPORT=${PGBENCH_PORT:=5432}

#First see if pgisready ??

cd ~  
cat >> ".pgpass" <<-EOF
*:*:*:*:${PGBENCH_PASSWORD}
EOF
chmod 0600 .pgpass

export PGPASSFILE=~/.pgpass

while true; do
    pg_isready --dbname=$PGBENCH_DATABASE --host=$PGHOST \
	       --port=$PGPORT \
	       --username=$PGBENCH_USER --timeout=2
    if [ $? -eq 0 ]; then
	echo "database is ready"
	break
    fi
    sleep 2
done


if [ $NOLOAD = "false" ]; then
echo "Running pgbench against Host $1 in mode $2"
psql -p $PGPORT -h $PGHOST -c "create database $PGBENCH_DATABASE" -U $PGBENCH_USER
pgbench --host=$PGHOST \
        --port=$PGPORT \
        --username=$PGBENCH_USER \
        --scale=$SCALE_FACTOR \
        --initialize $PGBENCH_DATABASE

fi

#elif [ $PG_MODE = "run" ]; then
echo "Running pgbench against Host $1 in mode $2"
#
# run some load
#
for i in `seq 1 $ITERATIONS`
do
    echo "running iteration $i on $PGHOST"
    if [ $PG_MODE = "ro" ]; then
	pgbench -r -S --host=$PGHOST \
		--port=$PGPORT \
		--username=$PGBENCH_USER \
		--jobs=$NUM_JOBS \
		--time=$TIME_DURATION \
		--client=$NUM_CLIENTS \
		$PGBENCH_DATABASE
    elif [ $PG_MODE = "rw" ]; then
	pgbench -r --host=$PGHOST \
		--port=$PGPORT \
		--username=$PGBENCH_USER \
		--jobs=$NUM_JOBS \
		--time=$TIME_DURATION \
		--client=$NUM_CLIENTS \
		$PGBENCH_DATABASE
    else
	echo "Invalid run mode specified. Exiting ... "
	exit 1
    fi
done
#    else
#    echo "Invalid mode specified. Exiting .. "
#fi
    
