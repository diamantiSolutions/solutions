
use FileHandle;
use Getopt::Long;
use POSIX qw(strftime);

my $total =0;
my $itration =0;




$result = GetOptions("s=s" => \$myString, "h" => \$help,  "help" => \$help, "verbose" => \$verbose);

if ($help) {
  print "\nclaculate.pl [options]:  claculate wrk results\n";
  print "   -s=<wrk output string>   Output string from all wrk\n";
  print "   -h or -help           show help \n\n";
  print "   -verbose              Keep it verbose\n";
  exit;
}

#my $mystring= "
#Requests/sec:  38156.85
#Requests/sec:  39156.85
#";

print "$myString\n";
    
foreach (split(/\n/, $myString)) {
  if ($_ =~ /Requests\/sec:  (.*)/) {
	 print "$1\n";
	 $total=$total+$1;
	 $itration++;
  }
}

$avg=$total/$itration;

print "total Req/sec= $total\n";
print "avg   Req/sec= $avg\n";
