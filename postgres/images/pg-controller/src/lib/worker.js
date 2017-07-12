var pg = require('./pg');
var k8s = require('./k8s');
//var config = require('./config');
//var ip = require('ip');
//var async = require('async');
//var moment = require('moment');
//var dns = require('dns');
//var os = require('os');

var loopSleepSeconds = 30;//config.loopSleepSeconds;
//var unhealthySeconds = config.unhealthySeconds;

//var hostIp = false;
//var hostIpAndPort = false;

var oldMaster="";
var consuleIsStable=0;


var init =function(done) {
    //nothing?

    const { exec } = require('child_process');
    exec('./kubectlSetup.sh',(error, stdout, stderr) => {
	if (error) {
	    console.error(`exec error: ${error}`);
	    return;
	}
	console.log(`stdout: ${stdout}`);
	console.log(`stderr: ${stderr}`);
    });
    
    console.log('pg-controller: done init');

    done();
};




var workloop = function workloop() {

    //A) REACT on FAILOVER ( how to avoid bootup time?)
    
    //1) see if master is changed
    //1.1) if master is me?
    //      --> promote my pg to master.
    //1.2) if master is not me ?
    //      ---> modify my config to point to new master
    var master="";
    
    var request = require('request');
    request('http://localhost:8500/v1/status/leader', function (error, response, body) {
	
	if (!error && response.statusCode == 200) {
	    console.log("Current consul leader: <"+body+">") ;// Print the name of leader.
	    master=body.replace(/\"/g,'').split(":");
	    console.log("Current consul leader: <"+master[0]+">,<"+body.replace('"','')+">") ;// Print the name of leader.

	    //skip if master is found first time (oldMaster!="") as init script will take care of it.
	    // skip if new master is null , that means consul has not elected the master so wait.
	    if(master[0] != "") {
		if(oldMaster != ""){
		    console.log("Checking leader: comparing oldMaster: "+oldMaster+", new master: "+master[0]);
		    if(master[0] != oldMaster) {
			console.log("Checking leader: master changed from: "+oldMaster+" to new master: "+master[0]);
			consuleIsStable=0;
			if(master[0] == process.env.POD_IP){
			    console.log("I am the leader, will promote myself.");
			    promote();
			}
			else{
			    //modify config file
			    
			    // /pgdata/pg-2/recovery.conf 
			    //primary_conninfo = 'application_name=pg-2 host=172.16.137.11 port=5432 user=master'
			    
			    var replace = require("replace");
			    replace({
				regex: "primary_conninfo = .*",
				replacement: "primary_conninfo = \'host="+master[0]+" port=5432 user=master\'",
				paths: ['/pgdata/'+process.env.PGHOST+'/recovery.conf'],
				recursive: true,
				silent: false,
			    });
			    
			    //reload the pg 
			    //reloadPg();
			    //reload is not working for postgres, so lets destroy itself to get restarted.
			    console.log("I am slave, restarting myself");
			    //k8s.deletePodByName(process.env.POD_NAME,function(err) {
			    //	if(err){
			    //	    console.error('Error: pod delete failed'+err);
			    //	}
			    //});

			    const { exec } = require('child_process');
			    exec('./restartPg.sh',(error, stdout, stderr) => {
				if (error) {
				    console.error(`exec error: ${error}`);
				    return;
				}
				console.log(`stdout: ${stdout}`);
				console.log(`stderr: ${stderr}`);
			    });


			    

			    
			}
			
		    }
		    else{
			consuleIsStable=1;
		    }
		    
		}
		else{
		    console.log("First time New leader found, no action needed");
		    consuleIsStable=0;
		    
		}
		oldMaster=master[0];
		
		
	    }
	    else {
		console.log("No leader found, lets wait");
		consuleIsStable=0;
	    }
	}
	else{
	    console.log("Checking leader: ERROR:"+error+" , response: "+response+" , body: "+body);
	    consuleIsStable=0;
	}
    });    
    
    //B)  do postgress healthcheck and kill pod if its not alive.
    //    TBD: do we need to seperate the leader check and health chekc loop to be more efficient? or its better to do them sequentially.
    //         If time taken by each loop is not more than the expected hearbeat time we should be ok to run in sequence.
    if(consuleIsStable==1) {
	console.log('pg-controller: workloop: healthcheck');
	/*
	//1//get list of nodes(pods) in consule.
	
	var request = require('request');
	request('http://localhost:8500/v1/agent/members', function (error, response, body) {
	    
	    if (!error && response.statusCode == 200) {
		agents= JSON.parse(body);
		//2// for each node(pod) do a health check.
		
		for (var i = 0; i < agents.length; i++) {
		
		    //3// if node(pod)'s postgress is not alive delete the pod to restart it
		    
		    //FIXME ARVIND TODO: find default database?? do we need to pass database?
		    var connectionString = {
			host: agents[i].Addr,
			port: 5432,
			//database: 'puppies',
			user: 'pgbench',
			password: 'password'
		    };
		    
		    var isAlive=pg.isPodAlive(connectionString);
		    if(!isAlive){
			//check again 
			isAlive=pg.isPodAlive(connectionString);
			if(!isAlive){
			    //check again
			    isAlive=pg.isPodAlive(connectionString);
			    if(!isAlive){
				//even after checking three time not finding the postgress pod alive.
				//Lets kill it so that it will be rescheduled.
				//TBD how do we assure that same pod is not deleted multiple time.
				console.log('pg-controller: workloop: healthcheck failed: deleting pod');
				
				k8s.deletePodByName(agents[i].Name, function(err) {
				    //finish(err, db);
				    if(err){
					console.log('Error: pod delete failed'+err);
				    }
				});
				
				//var labels = getPodLabelCollection(process.env.MASTER_LABEL);
				//k8s.deletePods(labels,function(err) {
				//	if(err){
				//	    console.error('Error: pod delete failed'+err);
				//	}
				//});
				
			    }  
			}
		    }
		}
	    }
	    else{
		console.log("Health Check: get consul agents: ERROR:"+error+" , response: "+response+" , body: "+body);
		consuleIsStable=0;
	    }
	});


	*/
    }


    
    setTimeout(workloop, loopSleepSeconds * 1000);
    
};



var getPodLabelCollection = function(labelsIn) {
  var labels = labelsIn.split(',');
  for (var i in labels) {
    var keyAndValue = labels[i].split('=');
    labels[i] = {
      key: keyAndValue[0],
      value: keyAndValue[1]
    };
  }

  return labels;
};


function promote() {
    
    var fs = require('fs');

    console.log("Promoting self as master")
    
    fs.writeFile("/pgdata/pg-failover-trigger", "", function(err) {
	if(err) {
            console.log(err);
	}
	console.log("Triggered self to be master!");
	
    });
    
    // set lable "role=pgmaster"so that thaservice can connect to it.
    //k8.pod.patch( )
    k8s.labelPod(process.env.POD_NAME, "role","pgmaster", function(err) {
	if(err){
	    console.error('Error: pod labeling failed'+err);
	}
    });
    
}




function reloadPg() {


var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);

    
    var connectionStringAdmin = {
	host: 'localhost',
	port: 5432,
	user: 'postgres',
	password: 'password'
    };
    var dbAdmin = pgp(connectionStringAdmin);


    
    
    
    dbAdmin.any('select  pg_reload_conf()')
	.then(function (data) {
            console.log('reloaded pg confs');
	})
	.catch(function (err) {
	    console.log("failed relaoding pg: "+err);
	});
}



// ======
// var init = function(done) {
//     ARV TBD: we may not need this fucntion
    
//   //Borrowed from here: http://stackoverflow.com/questions/3653065/get-local-ip-address-in-node-js
//     var hostName = os.hostname();
//     console.log("Doing Worker Init");
//   dns.lookup(hostName, function (err, addr) {
//     if (err) {
//       return done(err);
//     }

//     hostIp = addr;
//     hostIpAndPort = hostIp + ':' + config.mongoPort;

//     done();
//   });
// };

// var workloop = function workloop() {
//   if (!hostIp || !hostIpAndPort) {
//     throw new Error('Must initialize with the host machine\'s addr');
//   }

//   //Do in series so if k8s.getMongoPods fails, it doesn't open a db connection
//   async.series([
//     k8s.getMongoPods,
//     mongo.getDb
//   ], function(err, results) {
//     var db = null;
//     if (err) {
//       if (Array.isArray(results) && results.length === 2) {
//         db = results[1];
//       }
//       return finish(err, db);
//     }

//     var pods = results[0];
//     db = results[1];

//     //Lets remove any pods that aren't running
//     for (var i = pods.length - 1; i >= 0; i--) {
//       var pod = pods[i];
//       if (pod.status.phase !== 'Running') {
//         pods.splice(i, 1);
//       }
// 	console.log("found mongo pod:",pod); 
//     }

//     if (!pods.length) {
//       return finish('No pods are currently running, probably just give them some time.');
//     }

//     //Lets try and get the rs status for this mongo instance
//     //If it works with no errors, they are in the rs
//     //If we get a specific error, it means they aren't in the rs
//     mongo.replSetGetStatus(db, function(err, status) {
//       if (err) {
//         if (err.code && err.code == 94) {
//           notInReplicaSet(db, pods, function(err) {
//             finish(err, db);
//           });
//         }
//         else if (err.code && err.code == 93) {
//           invalidReplicaSet(db, pods, status, function(err) {
//             finish(err, db);
//           });
//         }
//         else {
//           finish(err, db);
//         }
//         return;
//       }

//       inReplicaSet(db, pods, status, function(err) {
//         finish(err, db);
//       });
//     });
//   });
// };

// var finish = function(err, db) {
//   if (err) {
//     console.error('Error in workloop', err);
//   }

//   if (db && db.close) {
//     db.close();
//   }

//   setTimeout(workloop, loopSleepSeconds * 1000);
// };

// var inReplicaSet = function(db, pods, status, done) {
//   //If we're already in a rs and we ARE the primary, do the work of the primary instance (i.e. adding others)
//   //If we're already in a rs and we ARE NOT the primary, just continue, nothing to do
//   //If we're already in a rs and NO ONE is a primary, elect someone to do the work for a primary
//   var members = status.members;

//   var primaryExists = false;
//   for (var i in members) {
//     var member = members[i];

//     if (member.state === 1) {
//       if (member.self) {
//         return primaryWork(db, pods, members, false, done);
//       }

//       primaryExists = true;
//       break;
//     }
//   }

//   if (!primaryExists && podElection(pods)) {
//     console.log('Pod has been elected as a secondary to do primary work');
//     return primaryWork(db, pods, members, true, done);
//   }

//   done();
// };

// var primaryWork = function(db, pods, members, shouldForce, done) {
//   //Loop over all the pods we have and see if any of them aren't in the current rs members array
//   //If they aren't in there, add them
//   var addrToAdd = addrToAddLoop(pods, members);
//   var addrToRemove = addrToRemoveLoop(members);

//   if (addrToAdd.length || addrToRemove.length) {
//     console.log('Addresses to add:    ', addrToAdd);
//     console.log('Addresses to remove: ', addrToRemove);

//     mongo.addNewReplSetMembers(db, addrToAdd, addrToRemove, shouldForce, done);
//     return;
//   }

//   done();
// };

// var notInReplicaSet = function(db, pods, done) {
//   var createTestRequest = function(pod) {
//     return function(completed) {
//       mongo.isInReplSet(pod.status.podIP, completed);
//     };
//   };

//   //If we're not in a rs and others ARE in the rs, just continue, another path will ensure we will get added
//   //If we're not in a rs and no one else is in a rs, elect one to kick things off
//   var testRequests = [];
//   for (var i in pods) {
//     var pod = pods[i];

//     if (pod.status.phase === 'Running') {
//       testRequests.push(createTestRequest(pod));
//     }
//   }

//   async.parallel(testRequests, function(err, results) {
//     if (err) {
//       return done(err);
//     }

//     for (var i in results) {
//       if (results[i]) {
//         return done(); //There's one in a rs, nothing to do
//       }
//     }

//     if (podElection(pods)) {
//       console.log('Pod has been elected for replica set initialization');
//       var primary = pods[0]; // After the sort election, the 0-th pod should be the primary.
//       var primaryStableNetworkAddressAndPort = getPodStableNetworkAddressAndPort(primary);
//       // Prefer the stable network ID over the pod IP, if present.
//       var primaryAddressAndPort = primaryStableNetworkAddressAndPort || hostIpAndPort;
//       mongo.initReplSet(db, primaryAddressAndPort, done);
//       return;
//     }

//     done();
//   });
// };

// var invalidReplicaSet = function(db, pods, status, done) {
//   // The replica set config has become invalid, probably due to catastrophic errors like all nodes going down
//   // this will force re-initialize the replica set on this node. There is a small chance for data loss here
//   // because it is forcing a reconfigure, but chances are recovering from the invalid state is more important
//   var members = [];
//   if (status && status.members) {
//     members = status.members;
//   }

//   console.log("Invalid set, re-initializing");
//   var addrToAdd = addrToAddLoop(pods, members);
//   var addrToRemove = addrToRemoveLoop(members);

//   mongo.addNewReplSetMembers(db, addrToAdd, addrToRemove, true, function(err) {
//     done(err, db);
//   });
// };

// var podElection = function(pods) {
//   //Because all the pods are going to be running this code independently, we need a way to consistently find the same
//   //node to kick things off, the easiest way to do that is convert their ips into longs and find the highest
//   pods.sort(function(a,b) {
//     var aIpVal = ip.toLong(a.status.podIP);
//     var bIpVal = ip.toLong(b.status.podIP);
//     if (aIpVal < bIpVal) return -1;
//     if (aIpVal > bIpVal) return 1;
//     return 0; //Shouldn't get here... all pods should have different ips
//   });

//   //Are we the lucky one?
//   return pods[0].status.podIP == hostIp;
// };

// var addrToAddLoop = function(pods, members) {
//   var addrToAdd = [];
//   for (var i in pods) {
//     var pod = pods[i];
//     if (pod.status.phase !== 'Running') {
//       continue;
//     }

//     var podIpAddr = getPodIpAddressAndPort(pod);
//     var podStableNetworkAddr = getPodStableNetworkAddressAndPort(pod);
//     var podInRs = false;

//     for (var j in members) {
//       var member = members[j];
//       if (member.name === podIpAddr || member.name === podStableNetworkAddr) {
//         /* If we have the pod's ip or the stable network address already in the config, no need to read it. Checks both the pod IP and the
//         * stable network ID - we don't want any duplicates - either one of the two is sufficient to consider the node present. */
//         podInRs = true;
//         continue;
//       }
//     }

//     if (!podInRs) {
//       // If the node was not present, we prefer the stable network ID, if present.
//       var addrToUse = podStableNetworkAddr || podIpAddr;
//       addrToAdd.push(addrToUse);
//     }
//   }
//   return addrToAdd;
// };

// var addrToRemoveLoop = function(members) {
//     var addrToRemove = [];
//     for (var i in members) {
//         var member = members[i];
//         if (memberShouldBeRemoved(member)) {
//             addrToRemove.push(member.name);
//         }
//     }
//     return addrToRemove;
// };

// var memberShouldBeRemoved = function(member) {
//     return !member.health
//         && moment().subtract(unhealthySeconds, 'seconds').isAfter(member.lastHeartbeatRecv);
// };

// /**
//  * @param pod this is the Kubernetes pod, containing the info.
//  * @returns string - podIp the pod's IP address with the port from config attached at the end. Example
//  * WWW.XXX.YYY.ZZZ:27017. It returns undefined, if the data is insufficient to retrieve the IP address.
//  */
// var getPodIpAddressAndPort = function(pod) {
//   if (!pod || !pod.status || !pod.status.podIP) {
//     return;
//   }

//   return pod.status.podIP + ":" + config.mongoPort;
// };

// /**
//  * Gets the pod's address. It can be either in the form of
//  * '<pod-name>.<mongo-kubernetes-service>.<pod-namespace>.svc.cluster.local:<mongo-port>'. See:
//  * <a href="https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#stable-network-id">Stateful Set documentation</a>
//  * for more details. If those are not set, then simply the pod's IP is returned.
//  * @param pod the Kubernetes pod, containing the information from the k8s client.
//  * @returns string the k8s MongoDB stable network address, or undefined.
//  */
// var getPodStableNetworkAddressAndPort = function(pod) {
//   if (!config.k8sMongoServiceName || !pod || !pod.metadata || !pod.metadata.name || !pod.metadata.namespace) {
//     return;
//   }

//   var clusterDomain = config.k8sClusterDomain;
//   var mongoPort = config.mongoPort;
//   return pod.metadata.name + "." + config.k8sMongoServiceName + "." + pod.metadata.namespace + ".svc." + clusterDomain + ":" + mongoPort;
// };

// */

module.exports = {
  init: init,
  workloop: workloop
};
