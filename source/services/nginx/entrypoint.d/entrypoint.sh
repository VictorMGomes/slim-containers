#!/usr/bin/env bash

SCRIPT_CERT_PATH="/entrypoint.d/create_self-signed_cert.sh"
SCRIPT_NGINX_PATH="/entrypoint.d/configure_nginx.sh"

chmod +x "$SCRIPT_CERT_PATH"
chmod +x "$SCRIPT_NGINX_PATH"

# shellcheck disable=SC1090
source "$SCRIPT_CERT_PATH"

# shellcheck disable=SC1090
source "$SCRIPT_NGINX_PATH"

if [ "$ENVIRONMENT" = "development" ]; then
  CERT_DIR="/etc/nginx/ssl/self-signed"

  mkdir -p "$CERT_DIR"

  export CERT_DIR

  create_self_signed_cert "$CERT_DIR" "$DEFAULT_HOST" "$VIRTUAL_HOST"
  configure_nginx "$CERT_DIR" "$DEFAULT_HOST" "$VIRTUAL_HOST" "$ENVIRONMENT" "$PHP_FPM_NAME" "$APP_NAME"
fi

nginx -g 'daemon off;'
