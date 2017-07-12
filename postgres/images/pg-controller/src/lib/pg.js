var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};


var pgp = require('pg-promise')(options);



var isPodAlive=function isPodAlive(connectionString) {

    var db = pgp(connectionString);

    //FIXME ARVIND TODO: find default database?? and query default table.


    
    db.any('select true')
	.then(function (data) {
	    return 1;
	})
	.catch(function (err) {
	    return 0;
	});
    

}


module.exports = {
 isPodAlive: isPodAlive
};
