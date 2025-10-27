FROM alpine:3.21

RUN apk update && apk add --no-cache lighttpd curl

RUN mkdir -p /var/www/html/static

COPY site/* /var/www/html/static/
COPY conf/lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN chown -R lighttpd:lighttpd /var/www/html

CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]