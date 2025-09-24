ARG SETUP="setup_nginx.sh"
ENV SETUP=${SETUP}

FROM alpine:3.17

# create user and group www
# create directory for html files
# creates directory /run/nginx for PID files and UNIX sockets used by fastCGI
RUN apk add --no-cache nginx openssl curl vim sudo \
	&& adduser -D -g 'www' www\
	&& mkdir -p /www /run/nginx\
	&& chown -R www:www /var/lib/nginx /www /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/${SETUP} ${SETUP}

RUN chmod +x /${SETUP}

EXPOSE 443

# prevents container to run as root
USER www

ENTRYPOINT ["/${SETUP}"]

CMD ["nginx", "-g", "daemon off"]
