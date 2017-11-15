
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
	var scriptParams=' -n='+req.body.name+' -t='+req.body.dbType+' -r='+req.body.replication+' -s='+req.body.storage+' -m='+req.body.mirroring+' -net='+req.body.network+' -np='+req.body.netPerfTier+' -sp='+req.body.storagePerfTier+' -sapassword='+req.body.sapassword+' -pgmasterpassword='+req.body.pgmasterpassword+' -pguser='+req.body.pguser+' -pguserpassword='+req.body.pguserpassword+' -pgdb='+req.body.pgdb+' -pgrootpassword='+req.body.pgrootpassword+' -html';
	
        var shell = require('shelljs');
        if (!shell.which('perl')) {
            shell.echo('Sorry, this script requires perl');
            shell.exit(1);
        }

        shell.exec("perl /opt/dbaas/createDb.pl"+scriptParams,
		   function(code, stdout, stderr) {
		       console.log('Exit code:', code);
		       console.log('Program output:', stdout);
		       console.log('Program stderr:', stderr);
		       res.send(stdout);//+'Exit code:'+code.toString()+'Program stderr:'+stderr.toString());
		   }
		  );
        //var fs = require('fs');
        //fs.readFile('abc/abc.txt', function(err, buf) {
        //    res.send(buf.toString());
        //});
	
    });

    app.post('/initialShellData', function (req, res) {
	var shell = require('shelljs');
	shell.exec("perl /opt/dbaas/getCurrentServices.pl",
		   function(code, stdout, stderr) {
		       console.log('Exit code:', code);
		       console.log('Program output:', stdout);
		       console.log('Program stderr:', stderr);
		       res.send(stdout);//+'Exit code:'+code.toString()+'Program stderr:'+stderr.toString());
		   }
		  );
	//var fs = require('fs');
	//fs.readFile('abc/initData.txt', function (err, buf) {
        //    res.send(buf);
	//});
    });
    app.post('/scaleScript', function (req, res) {
	var scriptParams = ' ' + req.body.name + ' ' + req.body.newScale;
	var shell = require('shelljs'); 
	shell.exec("/opt/dbaas/scale.sh"+scriptParams,
		   function(code, stdout, stderr) {
		       console.log('Exit code:', code);
		       console.log('Program output:', stdout);
		       console.log('Program stderr:', stderr);
		       res.send(stdout);
		   }
		  );
    });
    app.post('/deleteScript', function (req, res) {
	var scriptParams = ' ' + req.body.name;
	var shell = require('shelljs'); 
	shell.exec("/opt/dbaas/deleteSvc.sh"+scriptParams,
		   function(code, stdout, stderr) {
		       console.log('Exit code:', code);
		       console.log('Program output:', stdout);
		       console.log('Program stderr:', stderr);
		       res.send(stdout);
		   }
		  );
    });
    
};
