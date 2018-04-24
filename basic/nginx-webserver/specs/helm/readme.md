## nginx: nginx web server chart (used for nginx ingress controller testing )

The chart installs a modified nginx web server according to the following pattern:

* A ConfigMap is used to store the nginx configuration. (templates/configmap.yaml)
* A Deployment is used to create a Replica Set of nginx pods. (templates/deployment.yaml)
* A Service is used to create a gateway to the pods running in the replica set (templates/service.yaml)
The values.yaml exposes a few of the configuration options in the charts, though there are some that are not exposed there.

following two images are supported:
1) For nginx Ingress Controller funcitonal testing this image will return the actual IP of the webserver iteself. It helps to confirm which servier actually serving bheing load balancer.
values.yaml (nginxdemos/hello)
2) For nginx Ingress Controller perf testing this image have the approproate static binary files (eg 1kb.bin, 1mb.bin etc), reguired to be read by load generators. 
values-perf.yaml (guptaarvindk/nginx-web:perf ???)
You can deploy this chart with `helm install ??docs/examples/nginx??`. Or you can see how this chart would render with helm install --dry-run --debug ??docs/examples/nginx??.