FROM alpine:3.21

# install server client
# shadow for user management ontop of Alpine busybox adduser / addgroup
# vim and sudo for debug
RUN apk add --no-cache\
    bash \
	mariadb \
    mariadb-client \
    mariadb-server-utils \
    su-exec \
    sudo

COPY tools/setup.sh /setup.sh
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /setup.sh

# indicates where to persist data on container
# should not be part of the writable layer
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]

CMD ["mariadbd-safe", "--user=mysql"]

