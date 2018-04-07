FROM risingstack/alpine:3.4-v7.9.0-4.4.0
#FROM centos:7

COPY package.json package.json  
RUN npm install
RUN npm install pg-promise@5 --save
RUN npm install bluebird@3 --save

RUN apk update && apk add jq

# Add your source files
COPY . .  
CMD ["npm","start"] 