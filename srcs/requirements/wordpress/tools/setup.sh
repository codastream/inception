#!/bin/sh

WP_ADMIN_PASSWORD = cat /run/secrets/wp_admin_password
WP_USER_PASSWORD = cat /run/secrets/wp_user_password
SQL_USER_PASSWORD = cat /run/secrets/sql_user_password

@echo "===Configurating Wordpress==="
wp config create \
  --allow-root \
  --dbname=$SQL_DATABASE \
  --dbuser=$SQL_USER \
  --dbpass=$SQL_USER_PASSWORD \
  --dbhost=mariadb:3306 \
  --path='/var/www/wordpress'

wp core install \
  --url=$WP_URL \
  --title="Inception"\
  --admin_user=$WP_ADMIN_LOGIN \
  --admin_password=$WP_ADMIN_PASSWORD \
  --admin_email=$WP_ADMIN_EMAIL \
  --skip-email

wp user create \
  $WP_USER_LOGIN \
  $WP_USER_EMAIL \
  --user_pass=$WP_USER_PASSWORD
  --role=author
  --porcelain

exec "$@"
