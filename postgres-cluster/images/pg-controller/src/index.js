var worker = require('./lib/worker');

console.log('Starting up pg-controller');

worker.init(function(err) {
  if (err) {
    console.error('Error trying to initialize pg-controller', err);
  }
    
    //wait for 20 sec before start controlling pg cluster. wait for cluster to be stable and ready. Need better mechanism than fixed delay.
    setTimeout(worker.workloop, 10 * 1000);
});
