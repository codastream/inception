#!/bin/bash

set -euxo pipefail
FTP_PASS=$(cat /run/secrets/ftp_user_password)
FTP_USER=ftpuser

# crate secure chroot directory
mkdir -p /var/run/vsftpd/empty
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
	mv /var/www/vsftpd.conf /etc/vsftpd.conf

	adduser --disabled-password --gecos "" \
          --home /var/www/wordpress/wp-content/uploads \
          --shell /bin/bash \
          --ingroup www \
          $FTP_USER 

	echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd &> /dev/null

	chown -R $FTP_USER:www /var/www/wordpress/wp-content/uploads
  chmod -R 2775 /var/www/wordpress/wp-content/uploads

	echo $FTP_USER >> /etc/vsftpd.userlist

fi



# # Create www user with UID 1001 if it doesn't exist
# if ! id -u www > /dev/null 2>&1; then
#   useradd -u 1001 -g www -d /var/www -s /sbin/nologin www
# fi

# # Create FTP user with UID 999 and add to www group (GID 1001)
# if ! id -u $FTP_USER > /dev/null 2>&1; then
#   mkdir -p /var/www/wordpress/wp-content/uploads
#   useradd -u 999 -g www -d /var/www/wordpress/wp-content/uploads -s /bin/bash $FTP_USER
#   echo "$FTP_USER:$FTP_PASS" | chpasswd
#   echo "$FTP_USER" | tee -a /etc/vsftpd.userlist
# fi

# chgrp -R www /var/www/wordpress/wp-content/uploads
# chmod -R 2775 /var/www/wordpress/wp-content/uploads /var/www/wordpress/wp-content/uploads /var/www/wordpress/wp-content/uploads/2025 /var/www/wordpress/wp-content/uploads/2025/10
# find /var/www/wordpress/wp-content/uploads -type d -exec chmod 2775 {} +
# find /var/www/wordpress/wp-content/uploads -type f -exec chmod 664 {} +

# sed -i -r "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
# sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

# echo "
# write_enable=YES
# chroot_local_user=YES
# local_enable=YES
# allow_writeable_chroot=YES
# pasv_enable=YES
# local_root=/var/www/wordpress/wp-content/uploads
# pasv_min_port=21100
# pasv_max_port=21110
# userlist_enable=YES
# userlist_deny=NO
# background=NO
# xferlog_enable=YES
# log_ftp_protocol=YES
# vsftpd_log_file=/var/log/vsftpd/vsftpd.log
# xferlog_file=/var/log/vsftpd/xferlog
# userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf

exec /usr/sbin/vsftpd /etc/vsftpd.conf