#!/bin/sh

FTP_USER_HOME="/var/www/wordpress/"

set -euxo pipefail

FTP_PASS=$(cat /run/secrets/ftp_user_password)

mkdir -p /var/log/vsftpd /etc/vsftpd /var/www/wordpress/wp-content/uploads

# adding www  user and group
if ! getent group www >/dev/null 2>&1; then
  groupadd -g 1001    -r www
fi
if ! getent passwd www >/dev/null 2>&1; then
  useradd  -u 1001    -r -g www -d /var/www               -s /sbin/nologin www
fi

# adding secure user for vsftpd
if ! getent passwd ftpsecure >/dev/null 2>&1; then
  useradd  -u 998     -r -g www -d /var/empty             -s /sbin/nologin -M ftpsecure
fi

# addding FTP user with a fixed UID/GID to avoid permission issues with wordpress files
if ! getent passwd ftpuser >/dev/null 2>&1; then
  useradd  -u 999     -r -g www -d $FTP_USER_HOME         -s /sbin/nologin -m ftpuser
  echo "$FTP_USER:$FTP_PASS" | chpasswd
fi

if [ ! -f /etc/vsftpd/vsftpd.user_list ]; then
  echo "$FTP_USER" | tee -a /etc/vsftpd/vsftpd.user_list
  chmod 644 /etc/vsftpd/vsftpd.user_list
fi

until [ -d "/var/www/wordpress/wp-content" ] && [ -f "/var/www/wordpress/wp-config.php" ]; do
  echo "Waiting for WordPress..."
  sleep 2
done

# Set ownership for WordPress files
chown -R www:www /var/www/wordpress
chmod -R 755 /var/www/wordpress

# Allow FTP user to write to wp-content/uploads
chown -R ftpuser:www /var/www/wordpress/wp-content/uploads
chmod -R 775 /var/www/wordpress/wp-content/uploads

echo "Running"

exec "$@"
