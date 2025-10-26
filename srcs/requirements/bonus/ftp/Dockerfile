FROM alpine:3.21

# shadow includes usermod
RUN apk add --no-cache vsftpd shadow

# -r creates system account
# -d specifies home dir
# -m creates home dir
# -M prevents home dir creation

COPY tools/setup.sh /usr/sbin/setup.sh
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /usr/sbin/setup.sh

# 20 - data port for active mode data transfer
# 21 - command port (mandatory)
# 21100-21110 - passive mode data transfer
EXPOSE 21 20 21100-21110

ENTRYPOINT [ "/usr/sbin/setup.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf" ]
