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
)

for d in "${dirs[@]}"
do
    mkdir -p "$DATA/$d"
done

chown -R $(id -u):$(id -g) $DATA

echo "=== End of directories setup ==="
