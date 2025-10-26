FROM debian:bookworm

RUN apt update -y \
    && apt install vsftpd lftp libpam-modules libpam-modules-bin -y

COPY ./tools/setup.sh /
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /setup.sh

CMD ["bash", "/setup.sh"]