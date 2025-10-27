FROM alpine:3.21

RUN apk add --no-cache redis su-exec

RUN mkdir -p /data /var/log/redis \
    && chown -R redis:redis /data /var/log/redis

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /etc/redis/redis.conf /usr/local/bin/setup.sh \
    && chown redis:redis /etc/redis/redis.conf

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/setup.sh"]