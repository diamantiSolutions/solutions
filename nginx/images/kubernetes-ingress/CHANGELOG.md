# Changelog

### 0.9.0

* [156](https://github.com/nginxinc/kubernetes-ingress/pull/156): Write a pem file with an SSL certificate and key atomically.
* [155](https://github.com/nginxinc/kubernetes-ingress/pull/155): Remove http2 annotation (http/2 can be enabled globally in the ConfigMap).
* [154](https://github.com/nginxinc/kubernetes-ingress/pull/154): Merge NGINX and NGINX Plus Ingress controller implementations.
* [151](https://github.com/nginxinc/kubernetes-ingress/pull/151): Use k8s.io/client-go.
* [146](https://github.com/nginxinc/kubernetes-ingress/pull/146): Fix health status.
* [141](https://github.com/nginxinc/kubernetes-ingress/pull/141): Set `worker_processes` to `auto` in NGINX configuration. Thanks to [Andreas Krüger](https://github.com/woopstar).
* [140](https://github.com/nginxinc/kubernetes-ingress/pull/140): Fix an error message. Thanks to [Andreas Krüger](https://github.com/woopstar).
* Update NGINX to version 1.13.3.

### 0.8.1

* Update NGINX version to 1.13.0.

### 0.8.0

* [117](https://github.com/nginxinc/kubernetes-ingress/pull/117): Add a customization option: location-snippets, server-snippets and http-snippets. Thanks to [rchicoli](https://github.com/rchicoli).
* [116](https://github.com/nginxinc/kubernetes-ingress/pull/116): Add support for the 301 redirect to https based on the `http_x_forwarded_proto` header. Thanks to [Chris](https://github.com/cwhenderson20).
* Update NGINX version to 1.11.13.
* Makefile updates: gcloud docker push command; golang container was updated to 1.8.
* Documentation fixes: [113](https://github.com/nginxinc/kubernetes-ingress/pull/113). Thanks to [Linus Lewandowski](https://github.com/LEW21).

### 0.7.0

* [108](https://github.com/nginxinc/kubernetes-ingress/pull/108): Support for the `server_tokens` directive via the annotation and in the configmap. Thanks to [David Radcliffe](https://github.com/dwradcliffe).
* [103](https://github.com/nginxinc/kubernetes-ingress/pull/103): Improve error reporting when NGINX fails to start.
* [100](https://github.com/nginxinc/kubernetes-ingress/pull/100): Add the health check location. Thanks to [Julian](https://github.com/jmastr).
* [95](https://github.com/nginxinc/kubernetes-ingress/pull/95): Fix the runtime.TypeAssertionError issue, which sometimes occurred when deleting resources. Thanks to [Tang Le](https://github.com/tangle329).
* [93](https://github.com/nginxinc/kubernetes-ingress/pull/93): Fix overwriting of Secrets with the same name from different namespaces.
* [92](https://github.com/nginxinc/kubernetes-ingress/pull/92/files): Add overwriting of the HSTS header. Previously, when HSTS was enabled, if a backend issued the HSTS header, the controller would add the second HSTS header. Now the controller overwrites the HSTS header, if a backend also issues it.
* [91](https://github.com/nginxinc/kubernetes-ingress/pull/91):
Fix the issue with single service Ingress resources without any Ingress rules: the controller didn't pick up any updates of the endpoints of the service of such an Ingress resource. Thanks to [Tang Le](https://github.com/tangle329).
* [88](https://github.com/nginxinc/kubernetes-ingress/pull/88): Support for the `proxy_hide_header` and the `proxy_pass_header` directives via annotations and in the configmap. Thanks to [Nico Schieder](https://github.com/thetechnick).
* [85](https://github.com/nginxinc/kubernetes-ingress/pull/85): Add the configmap settings to support perfect forward secrecy. Thanks to [Nico Schieder](https://github.com/thetechnick).
* [84](https://github.com/nginxinc/kubernetes-ingress/pull/84): Secret retry: If a certificate Secret referenced in an Ingress object is not found,
the Ingress controller will reject the Ingress object. but retries every 5s. Thanks to [Nico Schieder](https://github.com/thetechnick).
* [81](https://github.com/nginxinc/kubernetes-ingress/pull/81): Add configmap options to turn on the PROXY protocol. Thanks to [Nico Schieder](https://github.com/thetechnick).
* Update NGINX version to 1.11.8.
* Documentation fixes: [104](https://github.com/nginxinc/kubernetes-ingress/pull/104/files) and [97](https://github.com/nginxinc/kubernetes-ingress/pull/97/files). Thanks to [Ruilin Huang](https://github.com/hrl) and [Justin Garrison](https://github.com/rothgar).

### 0.6.0

* [75](https://github.com/nginxinc/kubernetes-ingress/pull/75): Add the HSTS settings in the configmap and annotations. Thanks to [Nico Schieder](https://github.com/thetechnick).
* [74](https://github.com/nginxinc/kubernetes-ingress/pull/74): Fix the issue of the `kubernetes.io/ingress.class` annotation handling. Thanks to [Tang Le](https://github.com/tangle329).
* [70](https://github.com/nginxinc/kubernetes-ingress/pull/70): Add support for the alpine-based image for the NGINX controller.
* [68](https://github.com/nginxinc/kubernetes-ingress/pull/68): Support for proxy-buffering settings in the configmap and annotations. Thanks to [Mark Daniel Reidel](https://github.com/df-mreidel).
* [66](https://github.com/nginxinc/kubernetes-ingress/pull/66): Support for custom log-format in the configmap. Thanks to [Mark Daniel Reidel](https://github.com/df-mreidel).
* [65](https://github.com/nginxinc/kubernetes-ingress/pull/65): Add HTTP/2 as an option in the configmap and annotations. Thanks to [Nico Schieder](https://github.com/thetechnick).
* The NGINX Plus controller image is now based on Ubuntu Xenial.

### 0.5.0

* Update NGINX version to 1.11.5.
* [64](https://github.com/nginxinc/kubernetes-ingress/pull/64): Add the `nginx.org/rewrites` annotation, which allows to rewrite the URI of a request before sending it to the application. Thanks to [Julian](https://github.com/jmastr).
* [62](https://github.com/nginxinc/kubernetes-ingress/pull/62): Add the `nginx.org/ssl-services` annotation, which allows load balancing of HTTPS applications. Thanks to [Julian](https://github.com/jmastr).

### 0.4.0

* [54](https://github.com/nginxinc/kubernetes-ingress/pull/54): Previously, when specifying the port of a service in an Ingress rule, you had to use the value of the target port of that port of the service, which was incorrect. Now you must use the port value or the name of the port of the service instead of the target port value. **Note**: Please make necessary changes to your Ingress resources, if ports of your services have different values of the port and the target port fields.
* [55](https://github.com/nginxinc/kubernetes-ingress/pull/55): Add support for the `kubernetes.io/ingress.class` annotation in Ingress resources.
* [58](https://github.com/nginxinc/kubernetes-ingress/pull/58): Add the version information to the controller. For each version of the NGINX controller, you can find a corresponding image on [DockerHub](https://hub.docker.com/r/nginxdemos/nginx-ingress/tags/) with a tag equal to the version. The latest version is available through the `latest` tag.

The previous version was 0.3


### Notes

* Except when mentioned otherwise, the controller refers both to the NGINX and the NGINX Plus Ingress controllers.
