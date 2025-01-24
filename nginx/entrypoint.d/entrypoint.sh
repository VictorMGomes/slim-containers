#!/usr/bin/env bash

chmod +x /entrypoint.d/create_self-signed_cert.sh
chmod +x /entrypoint.d/configure_nginx.sh

source /entrypoint.d/create_self-signed_cert.sh
source /entrypoint.d/configure_nginx.sh

if [ "$ENVIRONMENT" = "development" ]; then
  CERT_DIR="/etc/nginx/ssl/self-signed"

  mkdir -p "$CERT_DIR"

  export CERT_DIR

  create_self_signed_cert $CERT_DIR $DEFAULT_HOST $VIRTUAL_HOST
  configure_nginx $CERT_DIR $DEFAULT_HOST $VIRTUAL_HOST $ENVIRONMENT $PHP_FPM_NAME $APP_NAME
fi

nginx -g 'daemon off;'
