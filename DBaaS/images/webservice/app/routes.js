
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
        var scriptParams=' '+req.body.cost+' '+req.body.name+' '+req.body.dbType+' '+req.body.replication+' '+req.body.storage+' '+req.body.mirroring+' '+req.body.performance;
        var shell = require('shelljs');
        if (!shell.which('git')) {
            shell.echo('Sorry, this script requires git');
            shell.exit(1);
        }

        shell.exec("pwd; ls; cat run.sh;");
	
        shell.exec("ls run.sh; sh /opt/dbaas/run.sh"+scriptParams,
		   function(code, stdout, stderr) {
		       console.log('Exit code:', code);
		       res.send(stdout);
		       console.log('Program stderr:', stderr);
		   }
		  );
        //var fs = require('fs');
        //fs.readFile('abc/abc.txt', function(err, buf) {
        //    res.send(buf.toString());
        //});
	
    });

};
