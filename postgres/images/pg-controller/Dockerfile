FROM node:alpine
#FROM jcrugzz/alpine-node-kubernetes:6.9.4
#FROM centos:7

MAINTAINER Arvind Gupta <guptaarvindk@gmail.com>

WORKDIR /opt/pg-controller




#RUN yum -y update; yum clean all
#RUN yum -y install epel-release; yum clean all
#RUN yum -y install nodejs npm; yum clean all
#RUN yum -y install kubernetes-client; yum clean all


COPY package.json /opt/pg-controller/package.json


COPY ./kubectlSetup.sh /opt/pg-controller/kubectlSetup.sh
COPY ./restartPg.sh /opt/pg-controller/restartPg.sh
#COPY kubectl /opt/pg-controller/kubectl
RUN apk update && \
    apk upgrade && \
    apk add curl

RUN npm install
RUN npm install pg-promise@5 --save
RUN npm install bluebird@3 --save

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; 
RUN chmod +x ./kubectl;


COPY ./src /opt/pg-controller/src

CMD ["npm", "start"]
