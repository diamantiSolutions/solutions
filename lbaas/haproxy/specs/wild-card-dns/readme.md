# HAProxy setup with wildcard DNS.

***
This example is extension of haproxy/specs/stable example. It will use ingress controller and backends from haproxy/specs/stable example. For this example, we will use wildcard DNS *.cafe.example.com mapped to static endpoint/IP assigned for HAProxy instance.


### 1. setup ingress rules for wild card DNS
Setup cafe-wild-ingress.yaml with correct rules:
```
cat cafe-wild-ingress.yaml
...
spec:
  rules:
  - host: coffee.cafe.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: coffee-svc
          servicePort: 80
  - host: tea.cafe.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: tea-svc
          servicePort: 80
```

### 2. Create new Ingress configuration.
```
$ kubectl create -f cafe-wild-ingress.yaml
```
> please note that as no ingress-class is specified in ingress spec, these rules will be added in addition to rules added by Ingress spec in base example.


### 3.  Test North-south access to ingress controller         
Map wild card DNS entry *.cafe.example.com  to IP of HAproxy. And access *.cafe.example.com with respective subdomain name. Look at the response to make sure you are being served from correct and expected IP backends.
```
  curl http://water.cafe.example.com/ | grep address
  curl http://coffee.cafe.example.com/ | grep address
```




# Termination with wildcard SSL 
****

Following exmaple demonstrate how to setup TLS termination for HAProxy with wildcard DNS.

### 1. Create the wild card DNS entry
```
$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt
```

### 2. Specify common name as will card.
```
Common Name (eg, your name or your server's hostname) []:*.cafe.example.com
```

### 3. Create wildcard TLS secrete:
```
$ kubectl create secret tls haproxy-wild-tls --cert=/home/diamanti/tls/wild.cafe.example.com/registry.crt --key=/home/diamanti/tls/wild.cafe.example.com/registry.key
```

### 4. Update ingress controller spec to have tls entry for all possible domain.
```
cat cafe-wild-ingress-tls.yaml
...
spec:
  tls:
  - hosts:
  - tea.cafe.example.com
  - coffee.cafe.example.com
  - water.cafe.example.com
  secretName: haproxy-wild-tls
  rules:
  - host: coffee.cafe.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: coffee-svc
          servicePort: 80
  - host: tea.cafe.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: tea-svc
          servicePort: 80
  - host: water.cafe.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: water-svc
          servicePort: 80
```


### 5. create new modified ingress.
```
$ kubectl delete -f cafe-wild-ingress.yaml 
$ kubectl create -f cafe-wild-ingress-tls.yaml
```

### 6. Access it from outside or inside cluster using curl
```
curl https://tea.cafe.example.com/ -k | grep address
curl https://coffee.cafe.example.com/ -k | grep address
```
> Please note as we are using self signed certificate, curl will complain about the authenticity, so for testing purpose you can run curl with `-k` or `--insecure` option


Please note:
> * TLS setting in ingress spec need to have individual subdomain, wild card *.cafe.exmaple.com does not work
> * This setup will only work for *.cafe.example.com, not for cafe.example.com or *.*.cafe.example.com . If needed we can have different certs for other levels of domain. Another possibility is to have subjectAltName extension enabled for openSSL generation and CA.


***
> you can use run*.sh scripts in this dir to do everything in one step. But be aware that it assumes you don’t have any existing pods running. So its better to run the script first with delete option to cleanup.
```
./run.sh delete
./run.sh
```
