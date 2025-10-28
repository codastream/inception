#! /bin/sh

set -euo pipefail

ADMIN_PASS=$(cat "/run/secrets/portainer_admin_password")
echo $ADMIN_PASS

ADMIN_PASS_HASH=$(htpasswd -nb -B admin "$ADMIN_PASS" | cut -d ":" -f 2)

exec /usr/local/bin/portainer/portainer --data /data --admin-password "$ADMIN_PASS_HASH"