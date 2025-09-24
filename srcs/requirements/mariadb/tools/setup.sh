#!/bin/sh

# -e stop if a command fail
# -u unset variables as errors
# -o pipefail error if an intermediate command fails in a pipe
set -euo pipefail

# start in background
mysqld_safe --skip-networking & pid="$!"

# wait
# until mysqladmin ping >/dev/null 2>&1; do
#   echo "Waiting for MariaDB to start..."
#   sleep 2
# done

# create DB
mysql -uroot <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
  CREATE USER IF NOT EXISTS \`${SQL_ADMIN}\`@'localhost' IDENTIFIED BY '${SQL_ADMIN_PASSWORD}';
  CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_ADMIN}\`@'%' IDENTIFIED BY '${SQL_ADMIN_PASSWORD}';
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;
EOSQL

# refresh
mysqladmin -uroot -p'${SQL_ROOT_PASSWORD}' shutdown

exec "$@"

