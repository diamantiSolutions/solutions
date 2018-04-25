var express = require('express'),
  app = express(),
  port = 3000,
  mongoose = require('mongoose'),
  Task = require('./myModels'),
  bodyParser = require('body-parser');
  mongoose.Promise = global.Promise;

console.log('started node server. Connecting mongo server at '+process.env.MHOST+':'+process.env.MPORT);

/** Connection to mongo **/
mongoose.connect('mongodb://'+process.env.MHOST+':'+process.env.MPORT+'/cars'); 


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var routes = require('./routes/index');
routes(app);

app.listen(port);


console.log('RESTful API server started on: ' + port);

