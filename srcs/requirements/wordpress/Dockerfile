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
  php84-opcache \
  php84-pdo \
  php84-pdo_mysql \
  php84-json \
  php84-phar \
  php-mbstring \
  php84-curl \
  php84-gd \
  php84-zip \
  curl \
  mariadb-client

COPY tools/setup.sh /setup.sh

# symlink for php command used by cli
RUN ln -sf /usr/bin/php84 /usr/bin/php \
  && echo "memory_limit=512M" > /etc/php84/conf.d/memory-limit.ini \
  && curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp \
  && mkdir -p /run/php \
  && chmod +x /setup.sh


ENTRYPOINT ["/setup.sh"]

# -F foreground
CMD ["/usr/sbin/php-fpm8.4", "-F"]
