FROM node:alpine
#FROM centos:7

MAINTAINER Arvind Gupta <guptaarvindk@gmail.com>

WORKDIR /opt/cinema


COPY package.json /opt/cinema/package.json


RUN apk update && \
    apk upgrade && \
    apk add curl && \
    apk add git && \
    apk add perl && \
    apk add perl-switch
    

RUN npm install
RUN npm install -g bower

RUN bower install angular-sanitize  --allow-root
RUN bower install angular-spinner  --allow-root
#RUN bower install angular-ui-grid  --allow-root


COPY . /opt/cinema



#temp work around for bower stuff
RUN cp -r  bower_components/angular-spinner public/libs/
RUN cp -r  bower_components/angular-sanitize public/libs/
#RUN cp -r  bower_components/angular-ui-grid public/libs/
RUN cp -r  node_modules/angular-ui-grid public/libs/

CMD ["npm", "start"]
