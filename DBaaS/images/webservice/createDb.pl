#!/usr/bin/perl 
#-#w

################################################################################
## Company: DataWise Inc. Proprietary
## Engineer: agupta
## Create Date: 11/6/2015 12:18:00 PM
## Module Name: runRegr
## Project Name: Stevedore Prototype 1
## Description: 
##    regression script.
## Revision: 
##    Revision 0.01 - File Created
## Additional Comments: 
##    
################################################################################


use FileHandle;
use Getopt::Long;
use POSIX qw(strftime);
#use Net::OpenSSH;
#use JSON;
use Switch;

my @status;
my @dbip;

my $DB_TYPE="_UNKNOWN_";
my $MY_NAME="_UNKNOWN_";
my $NUM_DB_REPLICAS="_UNKNOWN_";
my $VOL_SIZE="_UNKNOWN_";
my $NUM_MIRRORS="_UNKNOWN_";
my $STORAGE_PERF_TIER="_UNKNOWN_";
my $MY_NETWORK="_UNKNOWN_";
my $MY_NET_PERF_TIER="_UNKNOWN_";
my $MY_MASTER_PASSWORD="_UNKNOWN_";
my $MY_USER="_UNKNOWN_";
my $MY_USER_PASSWORD="_UNKNOWN_";
my $MY_SA_PASSWORD="_UNKNOWN_";
my $MY_DATABASE_NAME="_UNKNOWN_";
my $MY_ROOT_PASSWORD="_UNKNOWN_";

my $BENCH_NET_PERF_TIER="best-effort";
my $BENCH_SCALE_FACTOR="600";
my $BENCH_ITRATIONS="100";
my $BENCH_NUM_CLIENTS="16";
my $BENCH_NUM_JOBS="2";
my $BENCH_DURATION="180";
my $noload="false";

my $success="false";

my $MODE="create";

my $startTime=localtime;

my $result = ""; ## so that this variable is used more than 1 time
$result = GetOptions("t=s" => \$DB_TYPE, "type=s" => \$DB_TYPE, 
		     "n=s" => \$MY_NAME, "name=s" => \$MY_NAME,
		     "r=n" => \$NUM_DB_REPLICAS, "replicas=n" => \$NUM_DB_REPLICAS,
		     "s=s" => \$VOL_SIZE, "size=s" => \$VOL_SIZE,
		     "m=n" => \$NUM_MIRRORS, "mirrors=n" => \$NUM_MIRRORS,
		     "sp=s" => \$STORAGE_PERF_TIER, "storageperftier=s" => \$STORAGE_PERF_TIER,
		     "net=s" => \$MY_NETWORK, "network=s" =>  \$MY_NETWORK,
		     "np=s" => \$MY_NET_PERF_TIER, "networkperftier=s" => \$MY_NET_PERF_TIER,
		     "sapassword" => \$MY_SA_PASSWORD,
		     "pgmasterpassword=s" => \$MY_MASTER_PASSWORD,
		     "pguser=s" => \$MY_USER,
		     "pguserpassword=s" => \$MY_USER_PASSWORD,
		     "pgdb=s" => \$MY_DATABASE_NAME,
		     "pgrootpassword=s" => \$MY_ROOT_PASSWORD,
		     "del" => \$delete,
		     "bench" => \$runBenchmark,
		     "noLoad" => \$noBenchMarkLoad,
		     "benchScale"=> \$BENCH_SCALE_FACTOR,
		     "benchItrations" => \$BENCH_ITRATIONS,
		     "benchNumClients" => \$BENCH_NUM_CLIENTS,
		     "benchNumJobs" => \$BENCH_NUM_JOBS,
		     "benchDuration" => \$BENCH_DURATION,
		     "verbose" => \$verbose,
		     "html" => \$html,
		     "h" => \$help,  "help" => \$help);


    

if ($help) {
    myPrint( "\ncreateDb.pl.pl [options]:     create Database as a service.\n");

}


if($delete) {
    $MODE="delete";
    myPrint( "destroying all the components of  selected Database service :  $MY_NAME\n");

}

 	
if($noBenchMarkLoad){
    $noload="true"
}
else{
    $noload="false"
}

#Qeestion,# mirror count goes in storage class or moved to PVC?
#Question,# How to figureout that databse name does not already exists?
#Question,# do we need interface to scale up/down and delete database interfaces?











    

#1.0) #Login as storage admin
`dctl login -u admin -p Pass1234!`;


#1.1) Create storage classes as needed

my $SC_NAME="diamanti-m".$NUM_MIRRORS."-".$STORAGE_PERF_TIER;

#if(`kubectl get storageclass | grep -c $SC_NAME` eq "0"){
    myPrint(`sed "s/<CLASS_NAME>/$SC_NAME/g" specs/postgres/diamanti-storage-class.tmpl | sed "s/<PERF_TIER>/$STORAGE_PERF_TIER/g" | sed "s/<MIRROR_COUNT>/$NUM_MIRRORS/g"| kubectl $MODE -f -`);
#}


#1.2) Create the volume with storage admin account.
#deploy PV
#??? PROBABLY creating PV is NOT needed , will be create with PVC itself automatically.
#For $i num of $NUM_DB_REPLICAS
#   VOL_NAME=$SERVICE_NAME-VOL-$i;
#   sed "s/VOLNAME/$VOL_NAME/g" pv.tmpl |  sed "s/VOLSIZE/$VOL_SIZE/g" |  sed "s/IOPERF/$IOPERF/g" | kubectl create -f -
#end for
   

#kind: PersistentVolume
 
#labels:
#      postgres/volume: VOLNAME
#    name: VOLNAME
 
#  capacity:
#      storage: VOLSIZE
#  options:
#        name: VOLNAME
#        perfTier: IOPERF



#2) create the databse service based on selected database type.
myPrint("creating database service $MY_NAME for $DB_TYPE");
 
switch($DB_TYPE){
    case "PostgresSQL" {

	my $joinString="";
	#create consul-configmap
	if($delete) {
	    myPrint( `kubectl $MODE configmap consul`);
	    
	}
	else{
	    #my $count=`kubectl get configmaps | grep -c consul`;
	    #print "|"+$count+"|";
	    #if(chomp($count) eq "0"){
		myPrint( `kubectl $MODE configmap consul --from-file=specs/postgres/consul-server-configmap.json`);
	    #}
	}
	#cretae pg-svc.yaml
	myPrint( `sed "s/<SVC_NAME>/$MY_NAME/g" specs/postgres/pg-svc.tmpl | kubectl $MODE -f -`);
	
	
	myPrint( `sed "s/<SVC_NAME>/$MY_NAME/g"  specs/postgres/pg-statefulset.tmpl | \
		    sed "s/<NUM_REPLICAS>/$NUM_DB_REPLICAS/g" | \
		    sed "s/<NETWORK>/$MY_NETWORK/g" | \
		    sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | \
		    sed "s/<STORAGE_CLASS>/$SC_NAME/g" | \
                    sed "s/<VOL_SIZE>/$VOL_SIZE/g" | \
		    sed "s/<MASTER_PASSWORD>/$MY_MASTER_PASSWORD/g" | \
		    sed "s/<USER>/$MY_USER/g" | \
		    sed "s/<USER_PASSWORD>/$MY_USER_PASSWORD/g" | \
		    sed "s/<DATABASE_NAME>/$MY_DATABASE_NAME/g" | \
		    sed "s/<ROOT_PASSWORD>/$MY_ROOT_PASSWORD/g" | \
		    sed "s/<CLUSTER_DOMAIN>/solutions.datawise.io/g" |\
		    kubectl $MODE -f -`);
	
	#myPrint( `sed "s/<SVC_NAME>/$MY_NAME/g" specs/postgres/pgpool.tmpl | \
	#    sed "s/<NETWORK>/$MY_NETWORK/g"  | \
	#    sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | \
	#    sed "s/<USER>/$MY_USER/g" | \
	#    sed "s/<USER_PASSWORD>/$MY_USER_PASSWORD/g" | \
	#    kubectl $MODE -f -`);
	    
	    
	    

	if(!$delete) {
	    #sleep 60
	    
	    #waiti while all the pods are in running state
	    my $done=1;
	    do{
		$done=1;
		sleep(10);
		myPrint("checking pod status...  \n\t ");
		my $myStatus="";
		for(my $i=0;$i<$NUM_DB_REPLICAS;$i++){
		    chomp($status[$i] = `kubectl get pods -o wide | grep \"$MY_NAME-.*-$i\" | awk 'END {print \$3 }'`);
		    #myPrint(`kubectl get pods -o wide | grep \"$MY_NAME-.*-$i\" | awk 'END {print \$3 }'`;
		    $myStatus .= "[".$i."]=>".$status[$i];
		    if($i<$NUM_DB_REPLICAS-1){
			$myStatus .= ","
		    }
		    else{
			$myStatus.="\n";
		    }
		    if($status[$i] eq "Running"){
			#print "Replica $i deployed\n";
			chomp($dbip[$i]=`kubectl get pods -o wide | grep \"$MY_NAME-.*-$i\" | awk 'END {print \$6 }'`);
		    }
		    else{
			$done=0;
		    }
		}
		myPrint($myStatus);
	    }
	    while(!$done); 
	    
	    
	    
	    for(my $i=0;$i<$NUM_DB_REPLICAS;$i++){
		if($i eq 0){
		    $joinString = '\n            - "-http-addr='.$dbip[$i].':8500"';
		}
	    else{
		$joinString .= '\n            - "'.$dbip[$i].'"';
	    }
	    }

	}
	
	myPrint( `sed "s/<IP_ADDR_LIST>/$joinString/g" specs/postgres/consul-join.tmpl| \
                    sed "s/<SVC_NAME>/$MY_NAME/g" | \
		    sed "s/<NETWORK>/$MY_NETWORK/g" | \
		    sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | \
                    kubectl $MODE -f -`);


	
		
	if($html){
	    myPrint("Database service <strong><font color=\"green\">$MY_NAME</font></strong> for $DB_TYPE is <strong><font color=\"green\">READY</font> </strong>\n");
	}
	else{
	    myPrint("Database service $MY_NAME for $DB_TYPE is READY\n");
	}
	$success="true";
	
	if($runBenchmark) {


	#wait for master to be picked ?? could be multiple of masters!!
	#kubectl get pods -l role=pgmaster

	    if(!$delete) {
		sleep(20);
	    }


	    myPrint( `perl runBench.pl -t=$DB_TYPE -n=$MY_NAME -net=$MY_NETWORK  -net=$MY_NETWORK -np=$BENCH_NET_PERF_TIER -noLoad=$noload  -pguser=$MY_USER -pguserpassword=$MY_USER_PASSWORD -pgdb=$MY_DATABASE_NAME  -benchScale=$BENCH_SCALE_FACTOR -benchItrations=$BENCH_ITRATIONS -benchNumClients=$BENCH_NUM_CLIENTS -benchNumJobs=$BENCH_NUM_JOBS -benchDuration=$BENCH_DURATION`)
		
	    
	}
	else{
	    
	    myPrint("you can run benchmark on this DB  using follwoing cmd:\n<br> <strong> perl runBench.pl -t=$DB_TYPE -n=$MY_NAME </strong>");
	    #myPrint("you can run benchmark on this DB  using follwoing cmd:\n<br> \
             #       sed \"s/<SVC_NAME>/$MY_NAME/g\"  specs/postgres/pgbench.tmpl | \
		#    sed \"s/<NETWORK>/$MY_NETWORK/g\" | \
		#    sed \"s/<NET_PERF_TIER>/$BENCH_NET_PERF_TIER/g\" | \
		#    sed \"s/<BENCH_NOLOAD>/$noload/g\" | \
		#    sed \"s/<BENCH_SCALE_FACTOR>/$BENCH_SCALE_FACTOR/g\" | \
		#    sed \"s/<BENCH_ITRATIONS>/$BENCH_ITRATIONS/g\" | \
		#    sed \"s/<BENCH_NUM_CLIENTS>/$BENCH_NUM_CLIENTS/g\" | \
		#    sed \"s/<BENCH_NUM_JOBS>/$BENCH_NUM_JOBS/g\" | \
		#    sed \"s/<BENCH_DURATION>/$BENCH_DURATION/g\" | \
		#    sed \"s/<USER>/$MY_USER/g\" | \
		#    sed \"s/<USER_PASSWORD>/$MY_USER_PASSWORD/g\" | \
		#    sed \"s/<DATABASE_NAME>/$MY_DATABASE_NAME/g\" | \
	        #    kubectl $MODE -f -");
	
	}
	
	
    }

    
    
    case "MongoDb" {
    
	#sed -e 's~<num>~0~g' mongo-node-template.yaml | kubectl $MODE -f -
	
	myPrint(`sed "s/<SVC_NAME>/$MY_NAME/g"  specs/mongo/mongo-statefulset.tmpl | \
		    sed "s/<NUM_REPLICAS>/$NUM_DB_REPLICAS/g" | \
		    sed "s/<NETWORK>/$MY_NETWORK/g" | \
		    sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | \
		    sed "s/<STORAGE_CLASS>/$SC_NAME/g" | \
                    sed "s/<VOL_SIZE>/$VOL_SIZE/g" | \
	            kubectl $MODE -f -`);

	
		
	if($html){
	    myPrint("Database service <strong><font color=\"green\">$MY_NAME</font></strong> for $DB_TYPE is <strong><font color=\"green\">READY</font> </strong>\n");
	}
	else{
	    myPrint("Database service $MY_NAME for $DB_TYPE is READY\n");
	}
	$success="true";





	
	if($runBenchmark) {


	#wait for master to be picked ?? could be multiple of masters!!
	#kubectl get pods -l role=pgmaster

	    if(!$delete) {
		sleep(40);
	    }

	    #`sed -e 's/qos/high/g' \
		#-e 's/NAME/mongo-bench/g' \
		#-e 's/DB_TYPE/mongo/g' \
		#-e 's/PHASE/load/g' \
		#-e 's/TARGET/172.16.137.13/g' \
		#-e 's/NET/default/g' \
		#specs/load/client-standalone.json | kubectl create -f -`;

	    #myPrint( `sed -e 's/qos/high/g' -e 's/NAME/$MY_NAME-bench/g' -e 's/DB_TYPE/mongo/g'  -e 's/TARGET/$MY_NAME-rs-0.$MY_NAME-mongo,$MY_NAME-rs-1.$MY_NAME-mongo,$MY_NAME-rs-2.$MY_NAME-mongo/g' -e 's/NET/default/g' specs/load/client-standalone.json | kubectl create -f -`);
	    myPrint( `perl runBench.pl -t=$DB_TYPE -n=$MY_NAME -net=$MY_NETWORK`);

	}
	else{
	    if(!$delete) {
		
		if($html){
		    myPrint( "you can run benchmark on this DB  using follwoing cmd:<br> <strong>perl runBench.pl -t=$DB_TYPE -n=$MY_NAME </strong>");
		}
		else{
		    myPrint( "you can run benchmark on this DB  using follwoing cmd:\n perl runBench.pl -t=$DB_TYPE -n=$MY_NAME -net=$MY_NETWORK" );
		    
		}
	    }
	    
	}


	
	
    }
    

    case "MsSQL" {
	
	myPrint(`sed "s/<SVC_NAME>/$MY_NAME/g"  specs/mssql/mssql-statefulset.tmpl | \
		    sed "s/<NUM_REPLICAS>/$NUM_DB_REPLICAS/g" | \
		    sed "s/<NETWORK>/$MY_NETWORK/g" | \
		    sed "s/<NET_PERF_TIER>/$MY_NET_PERF_TIER/g" | \
		    sed "s/<STORAGE_CLASS>/$SC_NAME/g" | \
                    sed "s/<VOL_SIZE>/$VOL_SIZE/g" | \
		    sed "s/<SA_PASSWORD>/$MY_SA_PASSWORD/g" | \
	            kubectl $MODE -f -`);

	
		
	if($html){
	    myPrint("Database service <strong><font color=\"green\">$MY_NAME</font></strong> for $DB_TYPE is <strong><font color=\"green\">READY</font> </strong>\n");
	}
	else{
	    myPrint("Database service $MY_NAME for $DB_TYPE is READY\n");
	}
	$success="true";


    }


    
    case "Cassandra" {
	myPrint("Cassandra db not supported yet\n");
	
	
    }

   
}


    #my $timeElapsed =  strftime "%H:%M:%S", (localtime-$startTime);
    
    #myPrint("time elapsed: $timeElapsed\n");
    
    if($success eq "false"){
	myPrint("<strong><font color=\"red\"> Database service $MY_NAME for $DB_TYPE FAILED to start</font> </strong>\n");
    }
 

sub myPrint { 
    my ($str) = @_;
    my $myTime = strftime "%H:%M:%S", localtime;
    chomp($str);
    print "$myTime: $str";

    if ($html) {
	print "<br>";
    }
    else{
	print "\n";
    }

    
}
