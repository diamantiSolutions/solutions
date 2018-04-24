var http = require('http');
var querystring = require('querystring');
const request = require('request');

module.exports = function(app) {

    // server routes ===========================================================
    // handle things like api calls
    // authentication routes

    // frontend routes =========================================================
    // route to handle all angular requests
    app.get('/theater', function(req, res) {
       
        res.status(200).json({
            "_id": {
                "$oid": "588ababf2d029a6d15d0b5bf"
            },
            "name": "Morelia",
            "state_id": "588aba4d2d029a6d15d0b5ba",
            "cinemas": ["588ac3a02d029a6d15d0b5c4", "588ac3a02d029a6d15d0b5c5"]
        });
       
    });

    app.get('/bookingData', function(req, res) {

        res.status(200).json({
            city: 'Morelia',
            cinema: 'Plaza Morelia',
            movie: {
                title: 'Assasins Creed',
                format: 'IMAX'
            },
            schedule: '10:45',
            cinemaRoom: 7,
            seats: ['45'],
            totalAmount: 71
        });
    });

    app.get('/cinemas', function(req, res) {
      
        res.status(200).json({
            "_id": {
                "$oid": "588ac3a02d029a6d15d0b5c4"
            },
            "name": "Plaza Morelia",
            "cinemaPremieres": [{
                    "id": "1",
                    "title": "Assasins Creed",
                    "runtime": 115,
                    "plot": "Lorem ipsum dolor sit amet",
                    "poster": "link to poster..."
                }, {
                    "id": "2",
                    "title": "Aliados",
                    "runtime": 124,
                    "plot": "Lorem ipsum dolor sit amet",
                    "poster": "link to poster..."
                }, {
                    "id": "3",
                    "title": "xXx: Reactivado",
                    "runtime": 107,
                    "plot": "Lorem ipsum dolor sit amet",
                    "poster": "link to poster..."
                }],
            "cinemaRooms": [{
                    "name": 1,
                    "capacity": 120,
                    "format": "IMAX",
                    "schedules": [{
                            "time": "10:15",
                            "seatsEmpty": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80],
                            "seatsOccupied": [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40],
                            "movie_id": "1",
                            "price": 54
                        }, {
                            "time": "4:35",
                            "seatsEmpty": [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40],
                            "seatsOccupied": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60],
                            "movie_id": "1",
                            "price": 71
                        }, {
                            "time": "6:55",
                            "seatsEmpty": [11, 12, 13, 14, 15, 16, 17, 18, 19, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80],
                            "seatsOccupied": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60],
                            "movie_id": "3",
                            "price": 79
                        }]
                }, {
                    "name": 2,
                    "capacity": 100,
                    "format": "Normal",
                    "schedules": [{
                            "time": "10:15",
                            "seatsEmpty": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60],
                            "seatsOccupied": [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39],
                            "movie_id": "2",
                            "price": 71
                        }]
                }, {
                    "name": 3,
                    "capacity": 80,
                    "format": "4DX",
                    "schedules": [{
                            "time": "10:15",
                            "seatsEmpty": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60],
                            "seatsOccupied": [61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80],
                            "movie_id": "3",
                            "price": 71
                        }]
                }],
            "city_id": "588ababf2d029a6d15d0b5bf"
        });
       
    });


    app.get('/moviesData', function(req, res) {

        //var fs = require('fs');
        //var movieObj = JSON.parse(fs.readFileSync("public/js/json/movies.txt", "utf8"));

	//performRequest('movie-svc:3000','/movies', 'GET', {}, function(movieObj) {
          //  console.log("route:moviesdData:"+movieObj);
	  //  res.send(movieObj);
	//});

	
	//getAPI('http://movie-svc:3000/movies'),function(data){res.send(data)});
	//getAPI('http://movie-svc:3000/movies')
	//    .then(data => {
	//	res.status(status.OK).json(data)
	//    })
	//    .catch(next)

		
	
	http.get('http://movie-svc:3000/movies', (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});
	
	
    });





    app.get('/moviesPremiere', function(req, res) {

	
	http.get('http://movie-svc:3000/movies/premieres', (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});
	
	
    });

    




    app.get('/movie', function(req, res) {
	http.get('http://movie-svc:3000/movies/'+req.query.movId, (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});
	
	
    });


    
    
    app.get('/theatersData', function(req, res) {

        //var fs = require('fs');
        //var theatersObj = JSON.parse(fs.readFileSync('public/js/json/theaters.txt', 'utf8'));
        //res.send(theatersObj);

	
	http.get('http://cinema-catalog-svc:3000/cinemas/'+req.query.cityId+'/'+req.query.movieId, (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});

	
    });


    app.get('/statesData', function(req, res) {

        //var fs = require('fs');
        //var statesObj = JSON.parse(fs.readFileSync('public/js/json/states.txt', 'utf8'));
        //res.send(statesObj);


	http.get('http://cinema-catalog-svc:3000/states', (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});
	
	

    });

    app.get('/citiesData', function(req, res) {

        //var fs = require('fs');
        //var citiesObj = JSON.parse(fs.readFileSync('public/js/json/cities.txt', 'utf8'));
        //res.send(citiesObj);


	http.get('http://cinema-catalog-svc:3000/cities?stateId='+req.query.stateId, (resp) => {
	    let data = '';
	    
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		res.send(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	});


	
    });


    
    app.get('*', function(req, res) {
        res.sendfile('./public/index.html');
    });


    

    app.post('/booking', function(req, res) {
	var myData= JSON.stringify(req.body)
	
	console.log("data="+myData);

	/*
	const options = {
	    hostname: 'booking-svc',
	    port: 3000,
	    path: '/booking',
	    method: 'POST',
	    headers: {
		'Content-Type': 'application/x-www-form-urlencoded',
		'Content-Length': myData.length
	    }
	};
	
	const hreq = http.request(options, (res) => {
	    console.log(`STATUS: ${res.statusCode}`);
	    console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
	    res.setEncoding('utf8');
	    res.on('data', (chunk) => {
		console.log("data on data="+myData);

		console.log(`BODY: ${chunk}`);
	    });
	    res.on('end', () => {
		console.log("data on end="+myData);
		console.log('\nNo more data in response.');
	    });
	    res.on('write', (data) => {
		console.log("data on write="+myData);
		console.log('\nwriting data to post req: ${data}.');
	    });
	});
	
	hreq.on('error', (e) => {
	    console.error('problem with request: ${e.message}');
	});
	
	// write data to request body
	console.log("data before write="+myData);
	hreq.write(myData);
	console.log("data before end="+myData);
	hreq.end();
	console.log("data after end="+myData);

	*/

	let options = {
	    url: 'http://booking-svc:3000/booking',
	    method: 'POST',
	    headers: {
		'Content-Type': 'application/json',
		'Content-Length': myData.length
	    },
	    body: myData,
	};
	request(options, function (error, response, body) {
	    console.log('error:', error); // Print the error if one occurred
	    console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
	    console.log('body:', body); // Print the HTML for the Google homepage.
	}).pipe(res);
	console.log("data="+myData);




	
    });


    


    
    app.post('/initialShellData', function(req, res) {
        var shell = require('shelljs');
        shell.exec("init.sh");
        var fs = require('fs');
        fs.readFile('abc/initData.txt', function(err, buf) {
            res.send(buf);
        });
    });




    app.post('/scaleScript', function(req, res) {
        var scriptParams = ' ' + req.body.name + ' ' + req.body.currentScale + ' ' + req.body.fld1;
        var shell = require('shelljs');
        shell.exec("scale.sh" + scriptParams);
        var fs = require('fs');
        fs.readFile('abc/scale.txt', function(err, buf) {
            res.send(buf);
        });
    });
    app.post('/submitForm', function(req, res) {
        var scriptParams = ' ' + req.body.cost + ' ' + req.body.name + ' ' + req.body.dbType + ' ' + req.body.replication + ' ' + req.body.storage + ' ' + req.body.mirroring + ' ' + req.body.performance;
        var shell = require('shelljs');
        if (!shell.which('git')) {
            shell.echo('Sorry, this script requires git');
            shell.exit(1);
        }

        shell.exec("test.sh" + scriptParams);
        var fs = require('fs');
        fs.readFile('abc/createDb.txt', function(err, buf) {
            res.send(buf);
        });
    });

};


// `createRequest` is also called by the constructor, after `processOptions`.
// This actually makes the request and processes the response, so `createRequest`
// is a bit of a misnomer.

var createRequest = function(request) {
  var timeout ;

  request.log.debug("Creating request ..");
  request.log.debug(request);

  var reqParams = {
    host: request.host,
    port: request.port,
    method: request.method,
    path: request.path + (request.query ? '?'+request.query : ""),
    headers: request.getHeaders(),
    // Node's HTTP/S modules will ignore this, but we are using the
    // browserify-http module in the browser for both HTTP and HTTPS, and this
    // is how you differentiate the two.
    scheme: request.scheme,
    // Use a provided agent.  'Undefined' is the default, which uses a global
    // agent.
    agent: request.agent
  };

  if (request.logCurl) {
    logCurl(request);
  }

  var http = request.scheme == "http" ? HTTP : HTTPS;

  // Set up the real request using the selected library. The request won't be
  // sent until we call `.end()`.
  request._raw = http.request(reqParams, function(response) {
    request.log.debug("Received response ..");

    // We haven't timed out and we have a response, so make sure we clear the
    // timeout so it doesn't fire while we're processing the response.
    clearTimeout(timeout);

    // Construct a Shred `Response` object from the response. This will stream
    // the response, thus the need for the callback. We can access the response
    // entity safely once we're in the callback.
    response = new Response(response, request, function(response) {

      // Set up some event magic. The precedence is given first to
      // status-specific handlers, then to responses for a given event, and then
      // finally to the more general `response` handler. In the last case, we
      // need to first make sure we're not dealing with a a redirect.
      var emit = function(event) {
        var emitter = request.emitter;
        var textStatus = STATUS_CODES[response.status] ? STATUS_CODES[response.status].toLowerCase() : null;
        if (emitter.listeners(response.status).length > 0 || emitter.listeners(textStatus).length > 0) {
          emitter.emit(response.status, response);
          emitter.emit(textStatus, response);
        } else {
          if (emitter.listeners(event).length>0) {
            emitter.emit(event, response);
          } else if (!response.isRedirect) {
            emitter.emit("response", response);
            //console.warn("Request has no event listener for status code " + response.status);
          }
        }
      };

      // Next, check for a redirect. We simply repeat the request with the URL
      // given in the `Location` header. We fire a `redirect` event.
      if (response.isRedirect) {
        request.log.debug("Redirecting to "
            + response.getHeader("Location"));
        request.url = response.getHeader("Location");
        emit("redirect");
        createRequest(request);

      // Okay, it's not a redirect. Is it an error of some kind?
      } else if (response.isError) {
        emit("error");
      } else {
      // It looks like we're good shape. Trigger the `success` event.
        emit("success");
      }
    });
  });
      // We're still setting up the request. Next, we're going to handle error cases
  // where we have no response. We don't emit an error event because that event
  // takes a response. We don't response handlers to have to check for a null
  // value. However, we [should introduce a different event
  // type](https://github.com/spire-io/shred/issues/3) for this type of error.
  request._raw.on("error", function(error) {
    request.emitter.emit("request_error", error);
  });

  request._raw.on("socket", function(socket) {
    request.emitter.emit("socket", socket);
  });

  // TCP timeouts should also trigger the "response_error" event.
  request._raw.on('socket', function () {
    request._raw.socket.on('timeout', function () {
      // This should trigger the "error" event on the raw request, which will
      // trigger the "response_error" on the shred request.
      request._raw.abort();
    });
  });


  // We're almost there. Next, we need to write the request entity to the
  // underlying request object.
  if (request.content) {
    request.log.debug("Streaming body: '" +
        request.content.data.slice(0,59) + "' ... ");
    request._raw.write(request.content.data);
  }

  // Finally, we need to set up the timeout. We do this last so that we don't
  // start the clock ticking until the last possible moment.
  if (request.timeout) {
    timeout = setTimeout(function() {
      request.log.debug("Timeout fired, aborting request ...");
      request._raw.abort();
      request.emitter.emit("timeout", request);
    },request.timeout);
  }

  // The `.end()` method will cause the request to fire. Technically, it might
  // have already sent the headers and body.
  request.log.debug("Sending request ...");
  request._raw.end();
};



function performRequest(host,endpoint, method, data, success) {
  var dataString = JSON.stringify(data);
  var headers = {};
  
    console.log("route:in perform request:");
    
    if (method == 'GET') {
	//endpoint += '?' + querystring.stringify(data);
    }
    else {
	headers = {
	    'Content-Type': 'application/json',
	    'Content-Length': dataString.length
	};
    }
  var options = {
    host: host,
    path: endpoint,
    method: method,
    headers: headers
  };

   
    console.log("performRequest: dataString:2="+dataString); 
    console.log("performRequest: host/endpoint="+host+"/"+endpoint);


    var req = http.request(options, function(res) {
	res.setEncoding('utf-8');
	
	var responseString = '';
	
	console.log("performRequest: http.request");
	
	res.on('data', function(data) {
	    responseString += data;
	    
	    console.log("performRequest: responseString="+responseString);
	});
	
	res.on('end', function() {
	    console.log(responseString);
	    var responseObject = JSON.parse(responseString);
	    success(responseObject);
	});
    });

    console.log("performRequest: dataString:2="+dataString);
    
  req.write(dataString);
  req.end();


};


const  getAPI = (url) => {
    return new Promise((resolve, reject) => {
	const data ='';
	http.get(url, (resp) => {
	    //let data = '';
	    // A chunk of data has been recieved.
	    resp.on('data', (chunk) => {
		data += chunk;
		console.log(data);
	    });
	    
	    // The whole response has been received. Print out the result.
	    resp.on('end', () => {
		//console.log(JSON.parse(data).explanation);
		console.log(data);
		resolve(data);
	    });
	    
	}).on("error", (err) => {
	    console.log("Error: " + err.message);
	    reject("error accessign API "+err)
	})
    })
}

