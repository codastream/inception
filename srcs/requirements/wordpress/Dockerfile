FROM alpine:3.21

ARG WP_ARCHIVE=wordpress.tar.gz
# fastCGI process manager
# mysql native driver
# php data objects
# opcache storing precompiled bytecode in memory
# phar php archive
# json required for REST API
# mbstring multibyte string functions - for UTF-8
# curl for updates and API calls
# gd graphic library
RUN apk add --no-cache php84 \
  php84-fpm \
  php84-mysqlnd \
  php84-mysqli \
  php84-pdo \
  php84-pdo_mysql \
  php84-opcache \
  php84-json \
  php84-session \
  php84-phar \
  php84-mbstring \
  php84-curl \
  php84-dom \
  php84-xml \
  php84-gd \
  php84-zip \
  bash \
  curl \
  mariadb-client

COPY conf/php-fpm.conf /etc/php84/php-fpm.conf
COPY conf/www.conf /etc/php84/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh

# symlink for php command used by cli
RUN ln -sf /usr/bin/php84 /usr/bin/php \
  && ln -sf /usr/sbin/php-fpm84 /usr/sbin/php-fpm \
  && addgroup -S www && adduser -S -G www www
  && echo "memory_limit=512M" > /etc/php84/conf.d/memory-limit.ini \
  && curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp \
  && mkdir -p /run/php \
  && chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]

# -F foreground
CMD ["/usr/sbin/php-fpm84", "-F"]
