FROM alpine:3.21

ENV SETUP=setup.sh

# create user and group www
# create directory for html files
# creates directory /run/nginx for PID files and UNIX sockets used by fastCGI
RUN apk add --no-cache nginx openssl curl vim sudo \
	&& adduser -D -g 'www' www\
	&& mkdir -p /var/www /run/nginx/ /etc/nginx/certs /var/lib/nginx/logs\
	&& touch /var/lib/nginx/logs/error.log\
	&& rm -f /etc/nginx/conf.d/*\
	&& rm -f /etc/nginx/nginx.conf\
	&& chown -R www:www /var/lib/nginx /var/lib/nginx/logs /var/lib/nginx/logs/error.log /run/nginx /etc/nginx/certs

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/${SETUP} ${SETUP}

RUN chmod +x /${SETUP}

EXPOSE 443

# prevents container to run as root
USER www

ENTRYPOINT ["/setup.sh"]

CMD ["nginx", "-g", "daemon off;"]
