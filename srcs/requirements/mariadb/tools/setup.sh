#!/bin/sh

# -e stop if a command fail
# -u unset variables as errors
# -o pipefail error if an intermediate command fails in a pipe
set -euo pipefail

chown -R mysql:mysql /var/lib/mysql
chmod 770 /var/lib/mysql

if [ -f "/run/secrets/sql_root_password" ]; then
    export SQL_ROOT_PASSWORD=$(cat /run/secrets/sql_root_password)
fi

if [ -f "/run/secrets/sql_admin_password" ]; then
    export SQL_ADMIN_PASSWORD=$(cat /run/secrets/sql_admin_password)
fi

if [ -f "/run/secrets/sql_user_password" ]; then
    export SQL_USER_PASSWORD=$(cat /run/secrets/sql_user_password)
fi

if [ ! -d /var/lib/mysql/mysql ]; then
    # chown -R mysql:mysql /var/lib/mysql;
    echo "Installing MariaDB..."

    # mariadb-secure-installation
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --skip-test-db

    echo "check /etc/my.cnf.d"
    ls /etc/my.cnf.d

    mariadbd --skip-networking --user=mysql --socket=/run/mysqld/mysqld.sock &    
    pid="$!"
    sleep 3

    envsubst < /etc/mysql/init.sql.template > /tmp/init.sql
    echo "init with env"
    cat /tmp/init.sql
    sed -i "s|_SQL_ROOT_PASSWORD_|$SQL_ROOT_PASSWORD|g" /tmp/init.sql
    sed -i "s|_SQL_ADMIN_PASSWORD_|$SQL_ADMIN_PASSWORD|g" /tmp/init.sql
    sed -i "s|_SQL_USER_PASSWORD_|$SQL_USER_PASSWORD|g" /tmp/init.sql
    echo "init with secrets"
    cat /tmp/init.sql
    mariadb < /tmp/init.sql

    mariadb-admin -uroot -p"${SQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock shutdown
    echo "waiting for temporary server shutdown"
    wait $pid
    echo "temp server down !"

fi

tail -n50 /var/lib/mysql/*.err

echo "NOW Starting MariaDB ..."

exec "$@"
