FROM alpine:3.21

RUN apk update && apk add --no-cache vsftpd

RUN mkdir -p /home/vsftpd /var/log/vsftpd /etc/vsftpd \
    && chown -R ftp:ftp /home/vsftpd

COPY tools/setup.sh /usr/sbin/setup.sh
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /usr/sbin/setup.sh

ENTRYPOINT [ "/usr/sbin/setup.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf" ]
