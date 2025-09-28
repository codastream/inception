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
    gettext \
    sudo \
    && rm -f /etc/my.cnf.d/* \
    && chown -R mysql:mysql /var/lib/mysql \
    && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY tools/setup.sh /setup.sh
COPY conf/init.sql.template /etc/mysql/init.sql.template
COPY conf/50-server.cnf /etc/my.cnf.d/

RUN chmod +x /setup.sh

# indicates where to persist data on container
# should not be part of the writable layer
VOLUME /var/lib/mysql

EXPOSE 3306

WORKDIR /usr

ENTRYPOINT ["sh", "/setup.sh"]

CMD [ "/usr/bin/mariadbd-safe", "--datadir=/var/lib/mysql", "--user=mysql"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD mariadb-admin ping -u root || exit 1