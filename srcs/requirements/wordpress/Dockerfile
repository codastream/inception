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
RUN apk add --no-cache php82 \
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
  php82-xml \
  php82-zip \
  bash \
  curl \
  mariadb-client

COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh
COPY --chmod=644 conf/post.txt /etc/wordpress/post.txt
COPY --chmod=644 conf/docker.jpeg /etc/wordpress/docker.jpeg

# symlink for php command used by cli
RUN ln -sf /usr/bin/php82 /usr/bin/php \
  && ln -sf /usr/sbin/php-fpm82 /usr/sbin/php-fpm \
  && addgroup -S www && adduser -S -G www www \
  && echo "memory_limit=512M" > /etc/php82/conf.d/memory-limit.ini \
  && curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp \
  && mkdir -p /run/php82 \
  && chmod +x /run/php82 \
  && chown -R www:www /run/php82 \
  && mkdir -p /var/www/wordpress \
  && chown -R www:www /var/www/wordpress \
  && chmod -R 755 /var/www/wordpress \
  && chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]

# -F foreground
CMD ["/usr/sbin/php-fpm82", "-F"]
