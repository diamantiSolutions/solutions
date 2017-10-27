FROM node:alpine
#FROM centos:7

MAINTAINER Arvind Gupta <guptaarvindk@gmail.com>

WORKDIR /opt/dbaas


COPY package.json /opt/dbaas/package.json


COPY ./kubectlSetup.sh /opt/dbaas/kubectlSetup.sh

RUN apk update && \
    apk upgrade && \
    apk add curl && \
    apk add git && \
    apk add perl && \
    apk add perl-switch
    

RUN npm install
#RUN npm install pg-promise@5 --save
#RUN npm install bluebird@3 --save

RUn npm install -g bower

RUN bower install angular-sanitize  --allow-root
RUN bower install angular-spinner  --allow-root

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; 
RUN chmod +x ./kubectl;
RUN cp ./kubectl /usr/local/bin

COPY . /opt/dbaas

#COPY ../../specs  /opt/dbaas/specs

#COPY ../../cleanCluster.sh /opt/dbaas/
#COPY ../../createDb.pl /opt/dbaas/
#COPY ../../launchDbs.pl /opt/dbaas/
#COPY ../../runBench.pl /opt/dbaas/

#temp work around for bower stuff
RUN cp -r  bower_components/angular-spinner/ public/libs/
RUN cp -r  bower_components/angular-sanitize public/libs/


CMD ["npm", "start"]
