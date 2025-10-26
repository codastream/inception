FROM debian:bookworm

RUN apt update -y \
    && apt install vsftpd -y

COPY ./tools/script.sh /
RUN chmod +x /script.sh

CMD ["/script.sh"]
