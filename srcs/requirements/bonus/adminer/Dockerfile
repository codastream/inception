FROM alpine:3.21

ENV PHP_V=php82
ENV DOC_ROOT=/var/www/html
ENV DOWNLOAD_URL=https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php
# ENV CSS_URL=https://www.adminer.org/static/themes/pepa-linha.css

RUN apk update && apk add --no-cache \
    wget \
    curl \
    ca-certificates \
    tzdata \
    ${PHP_V} \
    ${PHP_V}-common \
    ${PHP_V}-session \
    ${PHP_V}-curl \
    ${PHP_V}-mysqli \
    ${PHP_V}-openssl \
    ${PHP_V}-pdo \
    ${PHP_V}-pdo_mysql \
    ${PHP_V}-dom \
    ${PHP_V}-json \
    ${PHP_V}-mbstring \
    ${PHP_V}-xml \
    ${PHP_V}-simplexml \
    ${PHP_V}-fpm

    # ${PHP_V}-cli \
    # ${PHP_V}-exif \
    # ${PHP_V}-fileinfo \
    # ${PHP_V}-pecl-imagick \
    # ${PHP_V}-gd \
    # ${PHP_V}-mysqlnd \
    # ${PHP_V}-opcache \
    # ${PHP_V}-phar \
    # ${PHP_V}-tokenizer \
    # ${PHP_V}-zip

# RUN addgroup -g 1000 nginx && adduser -u 1000 -G nginx -D nginx

# 33 is common group id for www-data (used for servers)
# -S for system group / user
# -D does not have password
# -H does not have a home dir
RUN addgroup -g 33 -S www && \
    adduser -S -D -H -u 33 -G www www

# symlink for php version
RUN ln -s /usr/bin/${PHP_V} /usr/bin/php

#download adminer + theme
RUN mkdir -p ${DOC_ROOT} && curl -fsSL -o ${DOC_ROOT}/index.php ${DOWNLOAD_URL}
RUN chown -R www:www ${DOC_ROOT}
RUN chmod -R g+rwx ${DOC_ROOT}

#run, logs + rights
RUN mkdir -p /run/${PHP_V} /var/log/${PHP_V} \
    && touch /var/log/${PHP_V}/error_log \
    && chown -R www:www /etc/${PHP_V} /var/log/${PHP_V} /run \
    && chmod -R g+rwx /etc/${PHP_V} /var/log/${PHP_V} /run

COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

WORKDIR /var/www

# same port as wordpress
EXPOSE 9000

USER www

HEALTHCHECK --interval=30s\
            --timeout=5s\
            --retries=3 \
            CMD nc -z 127.0.0.1 9000 || exit 1

CMD [ "php-fpm82", "--nodaemonize", "--force-stderr" ]