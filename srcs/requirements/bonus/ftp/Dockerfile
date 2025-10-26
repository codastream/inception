FROM debian:bookworm

RUN apt update -y \
    && apt install vsftpd -y

COPY ./tools/setup.sh /
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x /setup.sh

CMD ["bash", "/setup.sh"]