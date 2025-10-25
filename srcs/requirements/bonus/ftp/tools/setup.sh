#!/bin/sh

set -euo pipefail

FTP_PASS=$(cat /run/secrets/ftp_user_password)

addgroup -g 1000 -S $FTP_USER || true
adduser -u 1000 -D -G $FTP_USER -h /home/vsftpd/$FTP_USER -s /bin/false $FTP_USER || true
chown -R $FTP_USER:$FTP_USER /home/vsftpd
echo "$FTP_USER:$FTP_PASS" | chpasswd

echo "$FTP_USER" > /etc/vsftpd.userList

chown -R $FTP_USER:$FTP_USER /var/www/wordpress
chmod -R 775 /var/www/wordpress
chmod -R 775 /var/www/wordpress/wp-content

echo "Running"

exec "$@"
