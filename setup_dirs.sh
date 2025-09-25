#!/bin/bash

set -euo pipefail

echo "=== Directories setup ==="

data="/home/fpetit/data"

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
    mkdir -p "$data/$d"
done

echo "=== End of directories setup ==="
