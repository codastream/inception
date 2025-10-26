#!/bin/bash

set -euxo pipefail
FTP_PASS=$(cat /run/secrets/ftp_user_password)
FTP_USER=ftpuser

# create secure chroot directory
mkdir -p /var/run/vsftpd/empty
chown root:root /var/run/vsftpd/empty
chmod 555 /var/run/vsftpd/empty

mkdir -p /var/log/vsftpd/

until [ -d "/var/www/wordpress/wp-content" ] && [ -f "/var/www/wordpress/wp-config.php" ]; do
  echo "Waiting for WordPress..."
  sleep 2
done

# Create www group with GID 1001 if it doesn't exist
if ! getent group www > /dev/null 2>&1; then
  groupadd -g 1001 www
fi

if [ ! -f "/etc/vsftpd.conf.bak" ]; then

  mkdir -p /var/run/vsftpd/empty
	cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

	adduser --disabled-password --gecos "" \
          --home /var/www/wordpress/wp-content/uploads \
          --shell /bin/bash \
          --ingroup www \
          $FTP_USER 

fi

echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd &> /dev/null

chown -R $FTP_USER:www /var/www/wordpress/wp-content/uploads
chmod -R 2775 /var/www/wordpress/wp-content/uploads

touch /etc/vsftpd.userlist
echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null
grep -qxF "$FTP_USER" /etc/vsftpd.userlist || echo "$FTP_USER" >> /etc/vsftpd.userlist
chown root:root /etc/vsftpd.userlist
chmod 644 /etc/vsftpd.userlist

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf