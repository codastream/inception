FROM alpine:3.21

RUN apk add --no-cache redis su-exec
    # && addgroup -g 1000 redis && adduser -u 1000 -G redis -D redis \
    # && mkdir -p /data && chown -R redis:redis /data

RUN mkdir -p /data /var/log/redis \
    && chown -R redis:redis /data /var/log/redis

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /etc/redis/redis.conf /usr/local/bin/setup.sh \
    && chown redis:redis /etc/redis/redis.conf

EXPOSE 6379

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/setup.sh"]

# USER redis

# CMD [ "redis-server", "/etc/redis/redis.conf" ]

HEALTHCHECK --interval=30s\
            --timeout=3s\
            --retries=3\
            CMD redis-cli ping || exit 1
        