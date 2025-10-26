#!/bin/sh

set -euo pipefail

if [ -f /run/secrets/redis_password ]; then
    echo "Found Redis secret!"
    REDIS_PASSWORD=$(cat /run/secrets/redis_password)
    sed -i "s|# requirepass.*|requirepass $REDIS_PASSWORD|" /etc/redis/redis.conf
else
    echo "Warning: No Redis password secret"
fi

exec su-exec redis redis-server /etc/redis/redis.conf