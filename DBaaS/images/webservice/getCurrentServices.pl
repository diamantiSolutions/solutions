#!/usr/bin/perl 
#-#w


my @status=split(/^/m,`kubectl get statefulsets | grep -v NAME`);
my $first="1";
my $json='{"services": [';
#print @status;
foreach $sts (@status) {
    my @mySts=split(/\s+/m, $sts);
    #print $mySts[0];
    if($first eq "1"){
	$first="0";
    }
    else{
	$json.=","
    }
    $json.= '{ "name": "'.$mySts[0].'","currentScale": '.$mySts[1].'}';  
    
}
$json.="]}";

print $json;
