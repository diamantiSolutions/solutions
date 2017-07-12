var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
//var connectionString = 'postgres://arvind-1-master:5432/puppies';

var connectionStringWr = {
    host: process.env.PG_MASTER,
    port: 5432,
    database: 'puppies',
    user: 'pgbench',
    password: 'password'
};
var dbWr = pgp(connectionStringWr);

var connectionStringRd = {
    host: process.env.PGHOST,
    port: 5432,
    database: 'puppies',
    user: 'pgbench',
    password: 'password'
};
var dbRd = pgp(connectionStringRd);

var connectionStringAdmin = {
    host: process.env.PGHOST,
    port: 5432,
    user: 'postgres',
    password: 'password'
};
var dbAdmin = pgp(connectionStringAdmin);


function getAllPuppies(req, res, next) {
  dbRd.any('select * from pups')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved ALL puppies'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function getSinglePuppy(req, res, next) {
  var pupID = parseInt(req.params.id);
  dbRd.one('select * from pups where id = $1', pupID)
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved ONE puppy'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function createPuppy(req, res, next) {
  req.body.age = parseInt(req.body.age);
  dbWr.none('insert into pups(name, breed, age, sex)' +
      'values(${name}, ${breed}, ${age}, ${sex})',
    req.body)
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Inserted one puppy'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function updatePuppy(req, res, next) {
  dbWr.none('update pups set name=$1, breed=$2, age=$3, sex=$4 where id=$5',
    [req.body.name, req.body.breed, parseInt(req.body.age),
      req.body.sex, parseInt(req.params.id)])
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Updated puppy'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function removePuppy(req, res, next) {
  var pupID = parseInt(req.params.id);
  dbWr.result('delete from pups where id = $1', pupID)
    .then(function (result) {
      /* jshint ignore:start */
      res.status(200)
        .json({
          status: 'success',
          message: `Removed ${result.rowCount} puppy`
        });
      /* jshint ignore:end */
    })
    .catch(function (err) {
      return next(err);
    });
}



function reloadPg(req, res, next) {
  dbAdmin.any('select  pg_reload_conf()')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'reloaded pg confs'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function getServerName(req, res, next) {
  dbAdmin.any('select inet_server_addr()')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'got server name'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}



module.exports = {
  getAllPuppies: getAllPuppies,
  getSinglePuppy: getSinglePuppy,
  createPuppy: createPuppy,
  updatePuppy: updatePuppy,
  removePuppy: removePuppy,
  reloadPg: reloadPg,
  getServerName:getServerName  
};
