FROM alpine:3.21

ARG FTP_USER
ARG FTP_UID=1002
ARG WWW_UID=1001
ARG WWW_GID=1001

ENV FTP_USER="${FTP_USER}"

# shadow includes usermod
RUN apk add --no-cache vsftpd shadow

# -D default no password
# -h sets home to /var/www
RUN mkdir -p /home/vsftpd /var/log/vsftpd /etc/vsftpd \
    && addgroup -g "${WWW_GID}" -S www \
    && adduser -u "${WWW_UID}" -D -G www -h /var/www -s /sbin/nologin www \
    && adduser -D -u "${FTP_UID}" -G www -h "/home/vsftpd/ftpuser" -s /sbin/nologin ftpuser

COPY tools/setup.sh /usr/sbin/setup.sh
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /usr/sbin/setup.sh

# 20 - data port for active mode data transfer
# 21 - command port (mandatory)
# 21100-21110 - passive mode data transfer
EXPOSE 21 20 21100-21110

ENTRYPOINT [ "/usr/sbin/setup.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf" ]
