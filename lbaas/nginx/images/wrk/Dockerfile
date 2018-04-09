FROM skandyla/wrk:alpine

MAINTAINER arvind gupta <guptaarivndk@gmail.com>

RUN apk update && apk add util-linux

RUN mkdir /data

COPY start.sh  /data/

# Set working directory.
WORKDIR /data

#RUN chmod +x /data/start.sh

# Define default command.
ENTRYPOINT ["/data/start.sh"]
