var Client = require('node-kubernetes-client');
var config = require('./config');
var util = require("util");

fs = require('fs');

var readToken = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/token');

var client = new Client({
  host: process.env.KUBERNETES_SERVICE_HOST + ":" + process.env.KUBERNETES_SERVICE_PORT,
  namespace: process.env.KUBE_NAMESPACE,
  protocol: 'http',
  version: 'v1',
  token: readToken
});




var deletePodByName = function deletePodByName(name, done){
    console.log("deletePods: debug: in delete pod");
    client.pods.delete(name, function (err, pod) {
	if (!err) {
	    console.log('deletePodByName:: deleted pod ' + JSON.stringify(pod));
	    done();
	} else {
	    console.log('deletePodByName: Error deleting pods:',JSON.stringify(err),"\n",JSON.stringify(pod));
	    assert(false);
	}
    });
}

    

var deletePods = function deletePods(label, done){
    console.log("deletePods: debug: in delete pod");
    
    client.pods.get(function (err, podResult) {
	if (err) {
	    console.log("deletePods: debug: Error in get pod");
   
	    return done(err);
	}

	var pods = [];
	for (var j in podResult) {
	    pods = pods.concat(podResult[j].items)
	    console.log("deletePods: debug: found pod:",podResult[j].items);
   
	}
	var results = [];
	for (var i in pods) {
	    var pod = pods[i];
	    console.log("deletePods: getPods: checking label: ",label,", against pod: ", pod);
	    if (podContainsLabels(pod, label)) {
		console.log("deletePods: getPods: label is matching for pod.id=",pod.metadata.uid,pod.metadata.name,": ",pod);
		//pod delete is nto working as expected, lets direclty send the API req.
		client.pods.delete(pod.metadata.name, function (err, pod) {
		    if (!err) {
			console.log('deletePods:: deleted pod ' + JSON.stringify(pod));
			done();
		    } else {
			console.log('deletePods: Error deleting pods:',JSON.stringify(err),"\n",JSON.stringify(pod));
			assert(false);
		    }
		    
		});
		
	    }
	}
    });
};


var labelPod = function labelPod( podName, label,labelVal, done){
    if(0){//k8 plugin is not supporting the pd lable change 
    var patchJson='[ {"op": "add", "path": "/metadata/labels/'+label+'", "value": "'+labelVal+'" }]'
    
    console.log("labelPods: debug: in label pod");
    client.pods.patch(podName, patchJson,function (err, pod) {
	if (!err) {
	    console.log('labelPod:: added lable ('+label+') to  pod: ' + JSON.stringify(pod));
	    done();
	} else {
	    console.log('labelPod: Error labeling pods:',JSON.stringify(err),"\n",JSON.stringify(pod));
	    assert(false);
	}
    });
    }


    const { exec } = require('child_process');
    exec('./kubectl label --overwrite=true pod '+podName+'  '+label+'='+labelVal, (error, stdout, stderr) => {
	if (error) {
	    console.error(`exec error: ${error}`);
	    return;
	}
	console.log(`stdout: ${stdout}`);
	console.log(`stderr: ${stderr}`);
    });


    
};


/*
var getMongoPods = function getPods(done) {
  client.pods.get(function (err, podResult) {
    if (err) {
      return done(err);
    }
    var pods = [];
    for (var j in podResult) {
      pods = pods.concat(podResult[j].items)
    }
    var labels = config.mongoPodLabelCollection;
    var results = [];
    for (var i in pods) {
	var pod = pods[i];
	console.log("debug: getPods:",pod);
      if (podContainsLabels(pod, labels)) {
	console.log("debug: getPods: is mongoPod: ",pod);
        results.push(pod);
      }
    }

    done(null, results);
  });
};

*/
var podContainsLabels = function podContainsLabels(pod, labels) {
  if (!pod.metadata || !pod.metadata.labels) return false;

  for (var i in labels) {
      var kvp = labels[i];
      console.log("podContainsLabels:  ",kvp, kvp.value, "pod-kvp:",pod.metadata.labels[kvp.key] );
    if (!pod.metadata.labels[kvp.key] || pod.metadata.labels[kvp.key] != kvp.value) {
      return false;
    }
  }

  return true;
};



module.exports = {
    //getMongoPods: getMongoPods
    deletePods:deletePods,
    deletePodByName:deletePodByName,
    labelPod:labelPod
};
