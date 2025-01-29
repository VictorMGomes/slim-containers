#!/usr/bin/env bash

configure_default() {

    local SCRIPT_PATH="/entrypoint.d/create_self-signed_cert.sh"
    chmod +x $SCRIPT_PATH
    # shellcheck disable=SC1090
    source $SCRIPT_PATH

    local NGINX_DEFAULT_HOST="$1"
    local CERT_DIR="$2"

    export NGINX_DEFAULT_HOST CERT_DIR

    envsubst "\$NGINX_DEFAULT_HOST \$CERT_DIR" </etc/nginx/templates/default.conf.template >/etc/nginx/conf.d/default.conf
    create_self_signed_cert "$CERT_DIR" "$NGINX_DEFAULT_HOST"
}
