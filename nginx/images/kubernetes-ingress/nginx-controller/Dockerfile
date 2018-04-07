FROM nginx:1.13.3

# forward nginx access and error logs to stdout and stderr of the ingress
# controller process
RUN ln -sf /proc/1/fd/1 /var/log/nginx/access.log \
	&& ln -sf /proc/1/fd/2 /var/log/nginx/error.log

COPY nginx-ingress nginx/templates/nginx.ingress.tmpl nginx/templates/nginx.tmpl /

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context
ADD nginx-repo.crt /etc/ssl/nginx/
ADD nginx-repo.key /etc/ssl/nginx/


RUN rm /etc/nginx/conf.d/*

RUN mkdir -p /etc/nginx/ssl
ADD default.pem /etc/nginx/ssl

ENTRYPOINT ["/nginx-ingress"]
