#!/bin/bash

function check_pgbench_tables() {
  psql --set 'ON_ERROR_STOP=' <<-EOSQL
    DO \$\$
      DECLARE
        pgbench_tables CONSTANT text[] := '{ "pgbench_branches", "pgbench_tellers", "pgbench_accounts", "pgbench_history" }';
        tbl text;
      BEGIN
        FOREACH tbl IN ARRAY pgbench_tables LOOP
          IF NOT EXISTS (
            SELECT 1
            FROM pg_catalog.pg_class c
            JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
            WHERE n.nspname = 'public'
            AND c.relname = tbl
            AND c.relkind = 'r'
          ) THEN 
            RAISE EXCEPTION 'pgbench table "%" does not exist!', tbl;
          END IF;
        END LOOP;
      END 
    \$\$;
EOSQL
  psql_status=$?
  
  case $psql_status in
    0) echo "All pgbench tables exist! We can begin the benchmark" ;;
    1) echo "psql encountered a fatal error!" ;;
    2) echo "psql encountered a connection error!" ;;
    3) echo "One or more tables was missing! Initializing the database.";;
  esac

  return $psql_status
}

function initialize_pgbench_tables() {
  echo '*********** Initializing pgbench tables ************'
  pgbench -i -F ${FILL_FACTOR:=100} -s ${SCALE_FACTOR} --foreign-keys
}

export SCALE_FACTOR=${SCALE_FACTOR:=100}
export ITERATIONS=${ITERATIONS:=10}
export NUM_CLIENTS=${NUM_CLIENTS:=100}
export NUM_JOBS=${NUM_JOBS:=10}
export TIME_DURATION=${TIME_DURATION:=300}
export PGDATABASE=${PGBENCH_DATABASE:=pgbench}
export PGUSER=${PGBENCH_USER:=pgbench}
export PGPASSWORD=${PGBENCH_PASSWORD:=password}
export PGHOST=${PGBENCH_HOST}
export PGPORT=${PGBENCH_PORT:=5432}

echo '*************** Waiting for postgres ***************'
echo '**                                                **'
echo "** PGDATABASE: ${PGDATABASE}                      **"
echo "** PGHOST:     ${PGHOST}                          **"
echo "** PGPORT:     ${PGPORT}                          **"
echo "** PGUSER:     ${PGUSER}                          **"
echo '**                                                **'
echo '****************************************************'

attempt=1
while (! pg_isready -t 1 ) && [[ $attempt -lt 100 ]]; do 
  sleep 1
done

if [[ $attempt -ge 100 ]]; then
  echo '!!!!                                          !!!!'
  echo '!!!!             BENCHMARK FAILED             !!!!'
  echo '!!!!                                          !!!!'
  echo '!!!!      postgres never became available     !!!!'
  echo '!!!!                                          !!!!'
  exit 1
fi

check_pgbench_tables
status=$?

if [[ $status -eq 3 ]]; then
  initialize_pgbench_tables
elif [[ $status -ne 0 ]]; then
  exit $status
fi

echo '***************   Running pgbench    ***************'

for run in `seq 1 $ITERATIONS`; do
  echo Starting run $run
  pgbench -c ${NUM_CLIENTS} -j ${NUM_JOBS} -M prepared -T ${TIME_DURATION} 
  echo
  echo
done
