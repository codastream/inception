#!/bin/sh

set -euo pipefail

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
SQL_USER_PASSWORD=$(cat /run/secrets/sql_user_password)
REDIS_PASSWORD=$(cat /run/secrets/redis_password)

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

if [ -f index.php ]; then

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

    wp option update blogname $WP_TITLE
    wp option update blogdescription "400e build"
    POST_CONTENT=$(cat /etc/wordpress/post.txt)
    wp post update 1 \
        --post_title="Ma vie au pays des conteneurs" \
        --post_content="$POST_CONTENT" \
        --allow-root\

    wp media import /etc/wordpress/docker.jpeg \
    --title="Life in containers" \
    --alt="Dockerized life" \
    --post_id=1 \
    --featured_image \
    --allow-root

mkdir -p /var/www/wordpress/wp-content/mu-plugins
cat > /var/www/wordpress/wp-content/mu-plugins/tt4-overrides.php << 'PHP'
<?php
/*
Plugin Name: TT4 Translation Overrides
Description: Overrides specific strings in Twenty Twenty-Four patterns.
*/

add_filter('gettext_with_context', function ($translation, $text, $context, $domain) {
    if ($domain === 'twentytwentyfour'
        && $context === 'Testimonial Text or Review Text Got From the Person'
        && $text === '“Études has saved us thousands of hours of work and has unlocked insights we never thought possible.”') {

        return '“Inception was a cool project to spend hours working on and has unlocked insights we never thought possible.”';
    }
    return $translation;
}, 10, 4);
PHP
    wp plugin list --status=must-use --allow-root

    mkdir -p /var/www/wordpress/favicon
    install -m 644 /etc/wordpress/favicon.ico /var/www/wordpress/favicon/favicon.ico
fi

chown -R www:www "$WP_PATH"
chmod -R 755 "$WP_PATH"
# ls /usr/sbin/

until nc -z "redis" "6379"; do
  echo "Waiting for Redis..."
  sleep 1
done
  echo "Redis up..."

# REDIS
wp config set WP_CACHE true --allow-root
wp config set WP_REDIS_HOST redis --type=constant --allow-root
wp config set WP_REDIS_PORT 6379 --type=constant --allow-root
wp config set WP_REDIS_TIMEOUT 1 --type=constant --allow-root
wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --type=constant --allow-root
wp config set WP_REDIS_READ_TIMEOUT 1 --type=constant --allow-root
wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root
wp config get WP_REDIS_HOST --type=constant --allow-root --path="$WP_PATH"
wp redis status --allow-root --path="$WP_PATH"

exec "$@"
