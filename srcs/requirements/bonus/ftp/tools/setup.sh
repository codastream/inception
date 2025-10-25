#!/bin/sh

set -euo pipefail

FTP_PASS=$(cat /run/secrets/ftp_user_password)

# ensure ftp user exists
if ! id "$FTP_USER" > /dev/null 2>&1; then
    echo "ERROR: user $FTP_USER missing; image must create it." >&2
    exit 1
fi
# ensure ftp user is in www group
if ! id -nG "$FTP_USER" | grep -qw www; then
  adduser "$FTP_USER" www || true
fi

# chown -R "$FTP_USER":"$FTP_USER" /home/vsftpd

if ! id -nG "$FTP_USER" | grep -qw www; then
  adduser "$FTP_USER" www || true
fi


echo "$FTP_USER:$FTP_PASS" | chpasswd

if [ ! -f /etc/vsftpd.user_list ]; then
  echo "$FTP_USER" > /etc/vsftpd.user_list
  chmod 644 /etc/vsftpd.user_list
fi

until [ -d "/var/www/wordpress/wp-content" ] && [ -f "/var/www/wordpress/wp-config.php" ]; do
  echo "Waiting for WordPress..."
  sleep 2
done

set -eux

# ensure group exist
getent group www >/dev/null || addgroup -S www
id -u www >/dev/null 2>&1 || adduser -S -D -G www -h /var/www -s /sbin/nologin www
adduser "$FTP_USER" www || true


mkdir -p /var/www/wordpress/wp-content/uploads

# ensure ftp user owns wordpress files
chown -R www:www /var/www/wordpress/wp-content/uploads
# gid bit 2 set so new files inherit group

find /var/www/wordpress/wp-content/uploads -type d -exec chmod 2775 {} +
chmod -R g+rw /var/www/wordpress/wp-content/uploads

# debug
ls -ld /var/www/wordpress/wp-content/uploads \
       /var/www/wordpress/wp-content/uploads/2025 \
       /var/www/wordpress/wp-content/uploads/2025/10 || true
id "$FTP_USER" || true

echo "Running"

exec "$@"
