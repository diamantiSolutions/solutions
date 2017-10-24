
module.exports = function (app) {

    // server routes ===========================================================
    // handle things like api calls
    // authentication routes

    // frontend routes =========================================================
    // route to handle all angular requests
    app.get('*', function (req, res) {
        res.sendfile('./public/index.html');
    });
    app.post('/submitForm',function (req,res){
        //var scriptParams=' '+req.body.cost+' '+req.body.name+' '+req.body.dbType+' '+req.body.replication+' '+req.body.storage+' '+req.body.mirroring+' '+req.body.performance;
	var scriptParams=' -n='+req.body.name+' -t='+req.body.dbType+' -r='+req.body.replication+' -s='+req.body.storage+' -m='+req.body.mirroring+' -net='+req.body.network+' -np='+req.body.netPerfTier+' -sp'+req.body.storagePerfTier+' -pgmasterpassword='+req.body.pgmasterpassword+' -pguser='+req.body.pguser+' -pguserpassword='+req.body.pguserpassword+' -pgdb='+req.body.pgdb+' -pgrootpassword='+req.body.pgrootpassword
	
        var shell = require('shelljs');
        if (!shell.which('git')) {
            shell.echo('Sorry, this script requires git');
            shell.exit(1);
        }

	//perl /opt/dbaas/createDb.pl -t=postgres -n=dbaas-pg-21 -r=3 -s=20 -m=3 -sp=high -net=default -np=high -pgmasterpassword=password -pguser=pgbench -pguserpassword=password -pgdb=pgbench -pgrootpassword=password -bench 
	
        shell.exec("perl /opt/dbaas/createDb.pl "+scriptParams,
		   function(code, stdout, stderr) {
		       res.send("logs:<br>"+stdout+'<br>Exit code:<br>'+code+'<br>Program stderr:<br>'+stderr);
		   }
		  );
        //var fs = require('fs');
        //fs.readFile('abc/abc.txt', function(err, buf) {
        //    res.send(buf.toString());
        //});
	
    });

};
