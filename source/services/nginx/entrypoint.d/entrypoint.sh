#!/usr/bin/env bash

SCRIPT_PATH="/entrypoint.d/configure_nginx.sh"
chmod +x $SCRIPT_PATH
# shellcheck disable=SC1090
source "$SCRIPT_PATH"

if [ "$GENERAL_ENVIRONMENT" = "development" ]; then
  CERT_DIR="/etc/nginx/ssl/self-signed"
  mkdir -p "$CERT_DIR"
  configure_nginx "$CERT_DIR" "$NGINX_DEFAULT_HOST" "$NGINX_VIRTUAL_HOSTS_CONFIG" "$GENERAL_ENVIRONMENT" "$GENERAL_APP_NAME" "$GENERAL_SERVICES_PREFIX"
fi

nginx -g 'daemon off;'
