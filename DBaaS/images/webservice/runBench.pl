#!/usr/bin/perl 

use Getopt::Long;
use POSIX qw(strftime);
use Switch;

my $DB_TYPE="_UNKNOWN_";
my $MY_NAME="_UNKNOWN_";
my $STORAGE_PERF_TIER="best-effort";
my $MY_NETWORK="default";
my $MY_NET_PERF_TIER="best-effort";
my $MY_MASTER_PASSWORD="password";
my $MY_USER="pgbench";
my $MY_USER_PASSWORD="password";
my $MY_DATABASE_NAME="pgbench";
my $MY_ROOT_PASSWORD="password";

my $BENCH_NET_PERF_TIER="best-effort";
my $BENCH_SCALE_FACTOR="600";
my $BENCH_ITRATIONS="100";
my $BENCH_NUM_CLIENTS="16";
my $BENCH_NUM_JOBS="2";
my $BENCH_DURATION="180";
my $noBenchMarkLoad="false";


$result = GetOptions("t=s" => \$DB_TYPE, "type=s" => \$DB_TYPE, 
		     "n=s" => \$MY_NAME, "name=s" => \$MY_NAME,
		     "sp=s" => \$STORAGE_PERF_TIER, "storageperftier=s" => \$STORAGE_PERF_TIER,
		     "net=s" => \$MY_NETWORK, "network=s" =>  \$MY_NETWORK,
		     "np=s" => \$MY_NET_PERF_TIER, "networkperftier=s" => \$MY_NET_PERF_TIER,
		     "pgmasterpassword=s" => \$MY_MASTER_PASSWORD,
		     "pguser=s" => \$MY_USER,
		     "pguserpassword=s" => \$MY_USER_PASSWORD,
		     "pgdb=s" => \$MY_DATABASE_NAME,
		     "pgrootpassword=s" => \$MY_ROOT_PASSWORD,
		     "del" => \$delete,
		     "noLoad=s" => \$noBenchMarkLoad,
		     "benchScale=n"=> \$BENCH_SCALE_FACTOR,
		     "benchItrations=n" => \$BENCH_ITRATIONS,
		     "benchNumClients=n" => \$BENCH_NUM_CLIENTS,
		     "benchNumJobs=n" => \$BENCH_NUM_JOBS,
		     "benchDuration=n" => \$BENCH_DURATION,
		     "verbose" => \$verbose,
		     "html" => \$html,
		     "h" => \$help,  "help" => \$help);


    
switch($DB_TYPE){
    case "PostgresSQL" {
	print `sed "s/<SVC_NAME>/$MY_NAME/g" specs/postgres/pgbench.tmpl | sed "s/<NETWORK>/$MY_NETWORK/g" | sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | sed "s/<BENCH_NOLOAD>/$noBenchMarkLoad/g" | sed "s/<BENCH_SCALE_FACTOR>/$BENCH_SCALE_FACTOR/g" | sed "s/<BENCH_ITRATIONS>/$BENCH_ITRATIONS/g" | sed "s/<BENCH_NUM_CLIENTS>/$BENCH_NUM_CLIENTS/g" | sed "s/<BENCH_NUM_JOBS>/$BENCH_NUM_JOBS/g" | sed "s/<BENCH_DURATION>/$BENCH_DURATION/g" | sed "s/<USER>/$MY_USER/g" | sed "s/<USER_PASSWORD>/$MY_USER_PASSWORD/g" | sed "s/<DATABASE_NAME>/$MY_DATABASE_NAME/g" | kubectl create -f -`;
    }
    case "MongoDb" {
	print `sed -e 's/qos/$MY_NET_PERF_TIER/g' -e 's/NAME/$MY_NAME-bench/g' -e 's/DB_TYPE/mongo/g'  -e 's/PHASE/load/g' -e 's/TARGET/$MY_NAME-rs-0.$MY_NAME-mongo,$MY_NAME-rs-1.$MY_NAME-mongo,$MY_NAME-rs-2.$MY_NAME-mongo/g' -e 's/NET/default/g' specs/load/client-standalone.json | kubectl create -f -`
	    
    }
    case default {
	print "NOT supported";
    }
    
}
