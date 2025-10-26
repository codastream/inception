#!/bin/bash

set -euxo pipefail
FTP_PASS=$(cat /run/secrets/ftp_user_password)

# crate secure chroot directory
mkdir -p /var/run/vsftpd/empty

# service vsftpd start

adduser $FTP_USER --disabled-password --gecos ""
echo "$FTP_USER:$FTP_PASS" | chpasswd
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist 

mkdir /home/$FTP_USER/ftp
chown nobody:nogroup /home/$FTP_USER/ftp
chmod a-w /home/$FTP_USER/ftp

mkdir /home/$FTP_USER/ftp/files
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ftp/files

sed -i -r "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

echo "
local_enable=YES
allow_writeable_chroot=YES
pasv_enable=YES
local_root=/home/$FTP_USER/ftp
pasv_min_port=21100
pasv_max_port=21110
userlist_enable=YES
userlist_deny=NO
background=NO
userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf

# service vsftpd stop

exec /usr/sbin/vsftpd /etc/vsftpd.conf