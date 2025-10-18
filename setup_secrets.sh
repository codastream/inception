#!/bin/bash

set -euo pipefail

echo "=== Secrets setup ==="

mkdir -p secrets

create_secret_file() {
	local filename="$1"
	local prompt="$2"
	local file="secrets/$filename"

	if [ ! -f $file ]; then
		# -p for prompt -s for silent (do not print on terminal)
		read -sp "$prompt" secret
		# newline
		echo ""
		echo -n "$secret" > $file
		chmod 600 $file
	fi
}

declare -a secrets=(
	"sql_root_password"
	"sql_admin_password"
	"sql_user_password"
	"wp_admin_password"
	"wp_user_password"
	"redis_password"
	"ftp_user_password"
)

for s in "${secrets[@]}"
do
	create_secret_file "$s.txt" "Enter $s:"
done

echo "=== End of secrets setup ==="

