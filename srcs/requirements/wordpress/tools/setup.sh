#!/bin/sh

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
SQL_USER_PASSWORD=$(cat /run/secrets/sql_user_password)

WP_PATH=/var/www/wordpress
WP_CONFIG="$WP_PATH/wp-config.php"

echo "===Wordpress setup==="

# mkdir -p "$WP_PATH"
cd "$WP_PATH"

if [ ! -f "$WP_PATH/wp-settings.php" ]; then
    echo "Downloading..."
    wp core download --path=/var/www/wordpress --allow-root
fi

until mariadb -h mariadb -u"$SQL_USER" -p"$SQL_USER_PASSWORD" \
    -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 3
done

echo "MariaDB ready!"

if [ ! -f "$WP_CONFIG" ]; then
    echo "Configuring db..."
    wp config create \
      --dbname=$SQL_DATABASE \
      --dbuser=$SQL_USER \
      --dbpass=$SQL_USER_PASSWORD \
      --dbhost="mariadb" \
      --dbcharset="utf8mb4" \
      --dbcollate="utf8mb4_general_ci" \
      --path="$WP_PATH" \
      --allow-root
fi

if ! wp core is-installed --path="$WP_PATH" --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
      --path="$WP_PATH" \
      --url=$WP_URL \
      --title=$WP_TITLE \
      --admin_user=$WP_ADMIN_LOGIN \
      --admin_password=$WP_ADMIN_PASSWORD \
      --admin_email=$WP_ADMIN_EMAIL \
      --skip-email \
      --allow-root
fi

if [ -n "${WP_USER:-}" ] && [ -n "${WP_USER_EMAIL:-}" ]; then
    if ! wp user get "$WP_USER_LOGIN" --path="$WP_PATH" --allow-root 2>/dev/null; then
    echo "Adding new user..."
    wp user create \
        $WP_USER_LOGIN \
        $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=$WP_USER_ROLE \
        --path="$WP_PATH" \
        --porcelain \
        --allow-root
    fi
fi
if ! wp theme is-active $WP_THEME; then
    echo "Setting theme..."
    wp theme install $WP_THEME --activate
fi

# chown -R www:www "$WP_PATH"
# chmod -R 755 "$WP_PATH"
# ls /usr/sbin/

exec "$@"
