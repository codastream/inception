FROM alpine:stable

RUN apk update && apk add --no-cache \
    wget \
    php82 \
    php82-cli \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-fpm \
    php82-pecl-imagick \
    php82-gd \
    php82-json \
    php82-mbstring \
    php82-mysqlnd \
    php82-mysqli \
    php82-opcache \
    php82-pdo \
    php82-pdo_mysql \
    php82-phar \
    php82-session \
    php82-tokenizer \
    php82-xml \
    php82-zip

RUN addgroup -g 1000 nginx && adduser -u 1000 -G nginx -D nginx \
    && ln -s /usr/bin/php82 /usr/bin/php \
    && ln -s /usr/sbin/ph-fpmp82 /usr/sbin/php-fpm \
    && mkdir -p /var/www/html/adminer \
    && mkdir -p /run/php82 /var/log/php82 \
    && chown -R 1000:1000 /var/www /etc/php82 /var/log/php82 /run \
    && chmod -R g+rwx /var/www /etc/php82 /var/log/php82 /run

RUN wget -0 /var/www/adminer/index.php "https://www.adminer.org/latest.php"

COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/wwww.conf

WORKDIR /var/www

USER 1000

CMD [ "php-fpm", "--nodaemonize", "--force-stderr" ]