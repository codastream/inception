#!/bin/sh

if [ ! -f /etc/nginx/certs/mycert.crt ]; then
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/mycert.key \
    -out /etc/nginx/certs/mycert.crt \
    -subj "/CN=FR/ST=NA/L=Angouleme/O=42/OU=42Angouleme/CN=fpetit.42.fr/UID=fpetit"
fi

# check permissions

chmod 600 /etc/nginx/certs/mycert.key

nginx -t

while [ ! -f /var/www/wordpress/wp-includes/version.php ]; do 
    echo "Waiting for WP files..."; sleep 3;
done

until nc -z -w 2 wordpress 9000; do
  echo "Waiting for php-fpm at wordpress:9000..."
  sleep 2
done

echo "Setup complete ... starting nginx ..."

# execute final CMD
exec "$@"
