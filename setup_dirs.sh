#!/bin/bash

set -euo pipefail

echo "=== Directories setup ==="

DATA="/home/fpetit/data"

# -a for arrays
declare -a dirs=(
    "adminer"
    "mariadb"
    "nginx"
    "redis"
    "wordpress"
    "portainer"
)

for d in "${dirs[@]}"
do
    echo "creating $DATA/$d and setting 755 perms"
    mkdir -p "$DATA/$d"
    chmod 755 "$DATA/$d"
done

chown -R $(id -u):$(id -g) $DATA
chown -R 999:999 "$DATA/mariadb"

echo "=== End of directories setup ==="
