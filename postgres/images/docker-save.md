---cluster-RAS----
docker pull guptaarvindk/diamanti-postgres:v1
docker save -o diamanti-postgres-v1.tar guptaarvindk/diamanti-postgres:v1

docker pull guptaarvindk/pg-controller:v1
docker save -o pg-controller-v1.tar guptaarvindk/pg-controller:v1

docker pull guptaarvindk/pgpool:v2
docker save -o pgpool-v2.tar guptaarvindk/pgpool:v2

docker pull consul:0.8.1
docker save -o consul-0.8.1.tar consul:0.8.1

----simple-HA-----
docker pull crunchydata/crunchy-pgpool:centos7-9.6-1.4.1
docker save -o crunchy-pgpool-centos7-9.6-1.4.1.tar  crunchydata/crunchy-pgpool:centos7-9.6-1.4.1

docker pull guptaarvindk/postgres-cluster:v1
docker save -o postgres-cluster-v1.tar guptaarvindk/postgres-cluster:v1

docker pull guptaarvindk/pg-watch:v1
docker save -o pg-watch-v1.tar guptaarvindk/pg-watch:v1
