#!/bin/sh

SQL_ADMIN_PASSWORD=$(cat /run/secrets/sql_admin_password)
SQL_USER_PASSWORD=$(cat /run/secrets/sql_user_password)
SQL_ROOT_PASSWORD=$(cat /run/secrets/sql_root_password)

echo $SQL_USER_PASSWORD
echo $SQL_ROOT_PASSWORD
echo $SQL_ADMIN_PASSWORD

# -e stop if a command fail
# -u unset variables as errors
# -o pipefail error if an intermediate command fails in a pipe
set -euo pipefail

mkdir -p /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Installing MariaDB..."

    # mariadb-secure-installation
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --skip-test-db

    chown -R mysql:mysql /var/lib/mysql /run/mysqld
    chmod 755 /run/mysqld

    # start in background
    # --skip-networking : disable TCP/IP only accepts connections from local machine
    # $! captures pid of background process
    mariadbd-safe --skip-networking --user=mysql --socket=/run/mysqld/mysqld.sock & pid="$!"
    # wait
    echo "Waiting for MariaDB to start..."
    until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
        sleep 2
    done

    echo "DB started!!!!!"
    # secure root user
    # create users from any host @ '%'
    echo "Initializing db and users..."

    mariadb -uroot -e "SQL" "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mariadb -uroot -e "SQL" "CREATE USER IF NOT EXISTS $SQL_ADMIN@'%' IDENTIFIED BY $SQL_ADMIN_PASSWORD;"
    mariadb -uroot -e "SQL" "CREATE USER IF NOT EXISTS $SQL_USER@'%' IDENTIFIED BY $SQL_USER_PASSWORD;"
    mariadb -uroot -e "SQL" "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO $SQL_ADMIN'@'%' IDENTIFIED BY $SQL_ADMIN_PASSWORD;"
    mariadb -uroot -e "SQL" "ALTER USER 'root'@'%' IDENTIFIED BY $SQL_ROOT_PASSWORD;"

    echo "Shutting down MariaDB temporary server ..."
    # refresh
    mariadb-admin -uroot -p"${SQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock shutdown
    # waiting for clean shutdown
    wait $pid

fi

tail -n50 /var/lib/mysql/*.err | grep "Error"

echo "Starting MariaDB ..."
exec su-exec mysql "$@"

