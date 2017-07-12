1) create a dctl volume (with appropriate mirroring)
dctl volume create pg-vol-single -s 20G -m 2

2) modify postgres-pod.json to use correct network.

3) create postgres isntance using above volume and netowrk.
kubectl create -f postgres-pod.json

4) Get into postgress instance:
kubectl exec -it  pg-single-XXXX /bin/sh

5) setup dummy data by running following cmds in the sell of instance:
psql -U postgres
ALTER ROLE pgbench WITH CREATEDB;
\q

psql -U pgbench 
DROP DATABASE IF EXISTS puppies;
CREATE DATABASE puppies;
\c puppies;
CREATE TABLE pups (
   ID SERIAL PRIMARY KEY,
   name VARCHAR,
   breed VARCHAR,
   age INTEGER,
   sex VARCHAR
);

INSERT INTO pups (name, breed, age, sex)  VALUES ('Tyler', 'Retrieved', 3, 'M');
\q

6) create sample application accessing the 
kubectl create -f nodejs-app.json


7) get into the app instance :
kubectl exec -it nodejs-pg-single-app-bef9g /bin/sh

8) access postgress to see if you get the same intialized data back:
curl http://localhost:3000/api/puppies


9) try writing to database by inserting one entry
curl --data "name=Whisky&breed=annoying&age=3&sex=f" http://localhost:3000/api/puppies

10) read it back:
curl http://localhost:3000/api/puppies

11) Please note that because of using mirroring option this this single instance solution is self recoverable and higly available. Only caveat is when node goes down it migh take max 5 min to come back.

