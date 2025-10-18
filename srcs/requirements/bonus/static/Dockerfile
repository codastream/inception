FROM alpine:3.21

RUN apk update && apk add --no-cache lighttpd

RUN mkdir -p /var/www/html

COPY conf/lighttpd.conf /etc/lighttpd/lighttpd.conf

EXPOSE 80

CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]