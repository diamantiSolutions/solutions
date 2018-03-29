
Demo-flow
1- show empty slate
2- create network.
3- create selfservice web pod
4- login to selfservice web
5- choose postgres and create db => show in diamnti GUI that DB is already running and ready to use.
6- choose mongo and create DB
7- create few more itraitons direclty from CLI showing use of scripting.
8- Show sclae up and down of mongo db and talk about how this can be automated with selfservice web for on demand scaling.
9- start load generation on postgres and show it on GUI. show how easy it was to create and use it. Show the output of loadgen logs directly from gui.


----

#clone the diamsnti solutiuons git repo:
 - please note currently MONGO DB bench mark wont work, so you can try creating the mongo database service but dont try running benchmark.
git clone https://github.com/diamantiSolutions/solutions.git

#go to DBaaS spec dir.
cd <repo>/DBaaS/spec

#launch selfservice web application container.
$ kubectl create -f webservice.yaml 
replicationcontroller "dbaasselfservice-rc" created
service "dbaasselfservice-app" created

#find the ip of the application
$ kubectl get pods -o wide | grep self
dbaasselfservice-rc-3bhqb   1/1       Running   0          8s        172.16.137.4    appserv36


#go to web browser and enter the aove IP on address bar to go to login page

#use following info to login. (Its a fake login)
   id:  admin
   pwd: admin

#name the database service and select specific database type. Change (or leave as it is) the rest of the fields.

#click on create database butoon.

# mongo DB will take 5-10 sec and postgres will take less than minute to complete.

# after completion it will print the log of the porcess and status READY for the service just created. At the end of log it will show a simple cmd to run the performance bench container.

Please note
 - cassandra db is not implemented as of now. So dont use it for creating database service
 - Its better to leave rest of the fields default  if you planning to run the the performance bench using the specified cmd by the output of "create dataabse" button. If any default value is changed, performance bench cmd wont work, and you will have to modify the runBench cmd to pass correct parameters. 
 - Remember when mongo db says its finished its still spawning the pods in background, So launch testbench only after it says status good on GUI. postgres will return only after all the pods running. So you can launch postgres bench immidiately.
 - Please put a disclaimer that this self service web is not a product and is only created for demo purpose.
 - please note that this is not just one instance of database but actually it is highly available, replicated, scalable, quickly recoverable syste.

# in GUI you will see that there will be N pods created for each service where N is number of replica selected. In addition there may be some more helper pods depending on database system.

#other than creating DB from GUI you can use following script to create postgress and mongo services.

cd ../images/webservice/
perl ./createDb.pl -t=MongoDb -n=arvind-mongo -r=3 -s=50 -m=2 -sp=high -net=default -np=high -bench
perl ./createDb.pl -t=PostgresSQL -n=dbaas-pg-3 -r=3 -s=20 -m=2 -sp=high -net=default -np=high -pgmasterpassword=password -pguser=pgbench -pguserpassword=password -pgdb=pgbench -pgrootpassword=password -bench

*please note that having -bench autostart a performance bench for you. 

#for help:
perl ./createDb.pl -h

# you can also use following script to 

perl launchDbs.pl -c=4

-each set consist of one mongo and one postgress service. So above cmd will create 8 database as service.
-please ignore "Already exists" error for storage class and config map.




