#!/usr/bin/env bash

configure_nginx() {
    local CERT_DIR="$1"
    local NGINX_DEFAULT_HOST="$2"
    local NGINX_VIRTUAL_HOSTS_CONFIG="$3"
    local GENERAL_ENVIRONMENT="$4"
    local GENERAL_APP_NAME="$5"
    local GENERAL_SERVICES_PREFIX="$6"

    sed -i 's|access_log .*|access_log /dev/stdout;|' /etc/nginx/nginx.conf
    sed -i 's|error_log .*|error_log /dev/stderr;|' /etc/nginx/nginx.conf

    local DEFAULT_SCRIPT="/entrypoint.d/configure_default.sh"
    chmod +x "$DEFAULT_SCRIPT"
    # shellcheck disable=SC1090
    source "$DEFAULT_SCRIPT"
    configure_default "$NGINX_DEFAULT_HOST" "$CERT_DIR"

    local VHOST_SCRIPT="/entrypoint.d/configure_vhosts.sh"
    chmod +x "$VHOST_SCRIPT"
    # shellcheck disable=SC1090
    source "$VHOST_SCRIPT"
    configure_vhosts "$NGINX_VIRTUAL_HOSTS_CONFIG" "$CERT_DIR" "$GENERAL_ENVIRONMENT" "$GENERAL_APP_NAME" "$GENERAL_SERVICES_PREFIX"
}
