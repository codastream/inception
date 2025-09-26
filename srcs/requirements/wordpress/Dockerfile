FROM alpine:3.21

ARG WP_ARCHIVE=wordpress.tar.gz
# fastCGI process manager
# mysql native driver
# php data objects
# opcache storing precompiled bytecode in memory
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
  # php84-json \
  # php-mbstring \
  php84-curl \
  php84-gd \
  php84-zip \
  curl \
  mariadb-client

# -P for destination
RUN curl -fL --A="Mozilla/5.0 (X11;Linux x86_64)" https://wordpress.org/wordpress-6.8.2.tar.gz \
    -o /var/www/wordpress.tar.gz

RUN cd /var/www \
  && tar -xzf ${WP_ARCHIVE} \
  && rm ${WP_ARCHIVE} \
  && chown -R root:root /var/www/wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp/wp-cli.phar

ENTRYPOINT /setup.sh

CMD ["/usr/sbin/php-fpm8.4", "-F;"]
