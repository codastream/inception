if [ ! -f /etc/nginx/certs/mycert.crt ]; then
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/mycert.key \
    -out /etc/nginx/certs/mycert.crt \
    -subj "/CN=FR/ST=NA/L=Angouleme/O=42/OU=42Angouleme/CN=xxx.42.fr/UID=xxx"
fi

# execute final CMD
exec "$@"
