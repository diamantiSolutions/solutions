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

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; 
RUN chmod +x ./kubectl;


COPY . /opt/dbaas

CMD ["npm", "start"]
