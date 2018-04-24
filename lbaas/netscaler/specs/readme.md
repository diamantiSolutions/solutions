-- daemonset was used for east-west traffic, need to understand.

-- RC is used for nort-south ingress. Ingress controller is running on MAS server, but ingress device (??) is running as pod on cluster.

-- MAS need to talk to node where Ingress pod is running. but it can not resolve appserv94, so we had to manually specify the HOST variable to appserv94.eng.diamanti.com