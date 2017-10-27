#!/usr/bin/perl 
#-#w

################################################################################
## Company: DataWise Inc. Proprietary
## Engineer: agupta
## Create Date: 11/6/2015 12:18:00 PM
## Module Name: runRegr
## Project Name: diamanti solutions
## Description: 
##    launch multiple databases
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

my $NUM_DBAAS=4;
my @perf =("best-effort","medium","high");

$result = GetOptions("c=n" => \$NUM_DBAAS, 
		     "h" => \$help,  "help" => \$help);
  

if ($help) {
    myPrint( "\nlaunchDbs.pl [options]:     create multiple  Database as a service and performance bench for each.\n \
               -c=<num of dbaas set>   each set consist of one mongo and one postgress service.\n");

}



for(my $i=0;$i<$NUM_DBAAS;$i++){
    my $j=$i%3;
    print `perl ./createDb.pl -t=PostgresSQL -n=dbrobot-pg-$i -r=3 -s=60 -m=2 -sp=$perf[$j] -net=default -np=$perf[$j] -pgmasterpassword=password -pguser=pgbench -pguserpassword=password -pgdb=pgbench -pgrootpassword=password -bench`;
    print `perl ./createDb.pl -t=MongoDb -n=dbrobot-mongo-$i -r=3 -s=150 -m=2 -sp=$perf[$j] -net=default -np=$perf[$j]  -bench`
	
} 
