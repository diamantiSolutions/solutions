
    var promise = require('bluebird');

    var options = {
	// Initialization Options
	promiseLib: promise,
	connect: (client, dc, isFresh) => {
            const cp = client.connectionParameters;
            //console.log('Connected to database:', cp.database);
	},
	query: e => {
            //console.log('QUERY:', e.query);
	},
	error: (err, e) => {
            if (e.cn) {
		// this is a connection-related error
		// cn = safe connection details passed into the library:
		//      if password is present, it is masked by #
		console.log("connection error");
            }
	    
            if (e.query) {
		// query string is available
		//console.log("query string is available" + e.query);
		if (e.params) {
                    // query parameters are available
		}
            }
	    
            if (e.ctx) {
		// occurred inside a task or transaction
		console.log("Error occurred inside a task or transaction");
            }
	}
    };
    
    
    var pgp = require('pg-promise')(options);



var isPodAlive=function isPodAlive(connectionString, alive, dead) {


    
    var db = pgp(connectionString);


    //console.log("connected to db: %j, connection: %j",db,connectionString);
    
    //FIXME ARVIND TODO: find default database?? and query default table.


    //console.log("isPgAlive?");
    
     db.any('select true')
     	.then(data => {
     	    //console.log("isPgAlive? yes:"+data);
     	    //return 1
	    alive();
     	})
     	.catch(error =>  {
     	    //console.log("isPgAlive? no:"+data);
     	    //return 0;
	    dead();
     	});

    
     // db.any('select * from pup')
     // 	.then(function (data) {
     // 	    res.status(200)
     // 		.json({
     // 		    status: 'success',
     // 		    data: data,
     // 		    message: 'Alive'
     // 		});
     // 	})
     // 	.catch(function (err) {
     // 	    return next(err);
     // 	});
    
    
}


module.exports = {
 isPodAlive: isPodAlive
};
