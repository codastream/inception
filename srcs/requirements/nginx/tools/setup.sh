#!/bin/sh

if [ ! -f /etc/nginx/certs/mycert.crt ]; then
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/mycert.key \
    -out /etc/nginx/certs/mycert.crt \
    -subj "/CN=FR/ST=NA/L=Angouleme/O=42/OU=42Angouleme/CN=fpetit.42.fr/UID=fpetit"
fi

# check permissions

chmod 600 /etc/nginx/certs/mycert.key

echo "Setup complete ... starting nginx ..."

# execute final CMD
exec "$@"
