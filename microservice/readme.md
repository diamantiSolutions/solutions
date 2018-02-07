
1.0 REFERRENCE:
This demo soluiton is loosely referred from:
https://github.com/Crizstian/cinema-microservice

1.1 You can find full description of this solution and microservics interaction at diamanti website:
<TBD>

2.0 Prerequisite 

2.1 download this solutions repository.
```
git clone https://github.com/diamantiSolutions/solutions.git
```

2.2 You need to have a mongodb database running in order to get this solution working. This solution assumes you have a mongodb instance (or cluster) running base don following example, for different mongo DB setup , please modify the env file for each microservice.
```
cd <cloned_dir>/mongodb-cluster/specs/ss/
./run.sh cinema
```
This will start a 3 member replica set for mongoDB which is highly availble, recoverable and scalable as described in ohter demos. it will start headless mongo service as well so that you can access all the mongo instances as:
```
cinema-rs-0.cinema-mongo:27017 cinema-rs-1.cinema-mongo:27017 cinema-rs-2.cinema-mongo:27017
```
2.3 if there is any change in above steps of mongo deplyment. please modify the env files in future steps.


3.0 prelaod database for our example

3.1 Setup and preload movie database:
```
kubectl exec -it cinema-rs-0 mongo sh

rs0:PRIMARY> admin=db.getSiblingDB("admin")
admin

rs0:PRIMARY> admin.createUser({user:"arvind", pwd:"arvindsmongo", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]})
Successfully added user: {
	"user" : "arvind",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	]
}

rs0:PRIMARY> db.getSiblingDB("admin").auth("arvind","arvindsmongo")
1
rs0:PRIMARY> use admin
switched to db admin
rs0:PRIMARY> db.grantRolesToUser( "arvind", [ "root" , { role: "root", db: "admin" } ] )
rs0:PRIMARY> use movies
switched to db movies
rs0:PRIMARY> db.movies.insertMany([{
      id: '1',
      title: 'Avengers: Infinity War',
      runtime: 115,
      format: 'IMAX',
      plot: 'Lorem ipsum dolor sit amet',
      releaseYear: 2018,
      releaseMonth: 10,
      releaseDay: 6
    }, {
      id: '2',
      title: 'Black Panther',
      runtime: 124,
      format: 'IMAX',
      plot: 'Lorem ipsum dolor sit amet',
      releaseYear: 2018,
      releaseMonth: 12,
      releaseDay: 13
    }, {
      id: '3',
      title: 'Jumanji: welcome to the jungle',
      runtime: 107,
      format: 'IMAX',
      plot: 'Lorem ipsum dolor sit amet',
      releaseYear: 2018,
      releaseMonth: 1,
      releaseDay: 20
    }, {
      id: '4',
      title: 'Star Wars: The last Jedai',
      runtime: 107,
      format: 'IMAX',
      plot: 'Lorem ipsum dolor sit amet',
      releaseYear: 2017,
      releaseMonth: 12,
      releaseDay: 27
    }, {
      id: '5',
      title: 'Coco',
      runtime: 114,
      format: 'IMAX',
      plot: 'Lorem ipsum dolor sit amet',
      releaseYear: 2017,
      releaseMonth: 11,
      releaseDay: 2
    }])
{
	"acknowledged" : true,
	"insertedIds" : [
		ObjectId("5a38341c72ca430d2212f266"),
		ObjectId("5a38341c72ca430d2212f267"),
		ObjectId("5a38341c72ca430d2212f268"),
		ObjectId("5a38341c72ca430d2212f269"),
		ObjectId("5a38341c72ca430d2212f26a")
	]
}


rs0:PRIMARY> exit
bye
```

3.2 copy over database json files to mongo master pod so that we can preload those data.
```
cd <cloned_dir>/microservice/specs/db/
kubectl cp cinemas.json default/cinema-rs-0:/
kubectl cp cities.json default/cinema-rs-0:/
kubectl cp countries.json default/cinema-rs-0:/
kubectl cp states.json default/cinema-rs-0:/
```

3.3 load the cinema catalog
```
kubectl exec -it cinema-rs-0 mongo sh

rs0:PRIMARY> mongoimport --db cinemas --collection countries --file countries.json --jsonArray -u arvind -p arvindsmongo --authenticationDatabase "admin"
rs0:PRIMARY> mongoimport --db cinemas --collection states --file states.json --jsonArray -u arvind -p arvindsmongo --authenticationDatabase "admin"
rs0:PRIMARY> mongoimport --db cinemas --collection cities --file cities.json --jsonArray -u arvind -p arvindsmongo --authenticationDatabase "admin"
rs0:PRIMARY> mongoimport --db cinemas --collection cinemas --file cinemas.json --jsonArray -u arvind -p arvindsmongo --authenticationDatabase "admin"
```

4.0 launch all the microservices
```
cd <cloned_dir>/microservices/specs ;
./run.sh
```

4.1 find the IP address of frontend Cinema App:
kubectl get pods -o wide | grep cinema-app-deployment
cinema-app-deployment-3620067656-8586m               1/1       Running            0          18h       172.16.137.31    appserv94


4.2 Point your browser to following address and start interacting with the application.:
``
http://<IP_Address>:3000
``

4.3 delete all the microservice:

kubectl delete -f deploy.yaml


