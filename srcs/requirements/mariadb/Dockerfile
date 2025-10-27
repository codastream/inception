FROM alpine:3.21

# install server client
# shadow for user management ontop of Alpine busybox adduser / addgroup
# vim and sudo for debug
RUN apk add --no-cache\
	mariadb \
    mariadb-client \
    mariadb-server-utils \
    bash \
    su-exec \
    gettext \
    && rm -f /etc/my.cnf.d/* \
    && chown -R mysql:mysql /var/lib/mysql \
    && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY tools/setup.sh /setup.sh
COPY conf/init.sql.template /etc/mysql/init.sql.template
COPY conf/50-server.cnf /etc/my.cnf.d/

RUN chmod +x /setup.sh

WORKDIR /usr

ENTRYPOINT ["sh", "/setup.sh"]

CMD [ "/usr/bin/mariadbd-safe", "--datadir=/var/lib/mysql", "--user=mysql"]