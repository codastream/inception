#!/bin/sh

# -e stop if a command fail
# -u unset variables as errors
# -o pipefail error if an intermediate command fails in a pipe
set -euo pipefail

# SQL_ROOT_PASSWORD="rootpassword"
# SQL_ADMIN_PASSWORD="adminpassword"
# SQL_USER_PASSWORD="userpassword"

if [ -f "/run/secrets/sql_root_password" ]; then
    export SQL_ROOT_PASSWORD=$(cat /run/secrets/sql_root_password)
fi

if [ -f "/run/secrets/sql_admin_password" ]; then
    export SQL_ADMIN_PASSWORD=$(cat /run/secrets/sql_admin_password)
fi

if [ -f "/run/secrets/sql_user_password" ]; then
    export SQL_USER_PASSWORD=$(cat /run/secrets/sql_user_password)
fi

#echo $SQL_ROOT_PASSWORD
#echo $SQL_USER_PASSWORD
#echo $SQL_ADMIN_PASSWORD

# if [ ! -d "/run/mysqld" ]; then
#     mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld;
# fi

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

    # start in background
    # --skip-networking : disable TCP/IP only accepts connections from local machine
    # $! captures pid of background process
    #mariadbd --skip-networking --user=mysql --bootstrap << EOSQL
    #USE mysql;
    #FLUSH PRIVILEGES;
    #CREATE DATABASE IF NOT EXISTS $SQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
    #CREATE USER IF NOT EXISTS $SQL_ADMIN@'%' IDENTIFIED BY $SQL_ADMIN_PASSWORD;
    #CREATE USER IF NOT EXISTS $SQL_USER@'%' IDENTIFIED BY $SQL_USER_PASSWORD;
    #GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO $SQL_ADMIN'@'%' IDENTIFIED BY $SQL_ADMIN_PASSWORD;
    #ALTER USER 'root'@'%' IDENTIFIED BY $SQL_ROOT_PASSWORD;
    #FLUSH PRIVILEGES;
#EOSQL

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


    # echo "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" > init.sql
    # echo "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '$SQL_USER_PASSWORD';" >> init.sql
    # echo "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`${SQL_USER}\`@'%';" >> init.sql
    # echo "ALTER USER 'root'@'%' IDENTIFIED BY '$SQL_ROOT_PASSWORD';" >> init.sql
    # echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> init.sql
    # echo "FLUSH PRIVILEGES;" >> init.sql

    # cat init.sql
    # mariadb < init.sql
    mariadb-admin -uroot -p"${SQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock shutdown
    echo "waiting for temporary server shutdown"
    wait $pid
    echo "temp server down !"

    # mariadb -uroot -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
    # mariadb -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '$SQL_USER_PASSWORD';"
    # mariadb -uroot -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`${SQL_USER}\`@'%';"
    # mariadb -uroot -e "ALTER USER 'root'@'%' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"
    # mariadb -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
    # mariadb -uroot -e "FLUSH PRIVILEGES;"

    # --socket=/run/mysqld/mysqld.sock & pid="$! << EOSQL

    #envsubst '$SQL_DATABASE $SQL_USER $SQL_ADMIN' < /etc/mysql/init.sql.template > /etc/mysql/init.sql
    # sed -i "s|_SQL_ROOT_PASSWORD_|$SQL_ROOT_PASSWORD|g" /etc/mysql/init.sql
    # sed -i "s|_SQL_ADMIN_PASSWORD_|$SQL_ADMIN_PASSWORD|g" /etc/mysql/init.sql
    # sed -i "s|_SQL_USER_PASSWORD_|$SQL_USER_PASSWORD|g" /etc/mysql/init.sql
    #cat /etc/mysql/init.sql
    #sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
    #sed -i "s|.*bind-address\s*=*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

    # echo "Shutting down MariaDB temporary server ..."
    # refresh
    # mariadb-admin -uroot -p"${SQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock shutdown
    # waiting for clean shutdown
    # wait $pid
fi

tail -n50 /var/lib/mysql/*.err

echo "NOW Starting MariaDB ..."

exec "$@"
