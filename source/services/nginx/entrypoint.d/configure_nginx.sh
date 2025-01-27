#!/usr/bin/env bash

configure_nginx() {
    local CERT_DIR="$1"
    local DEFAULT_HOST="$2"
    local VIRTUAL_HOST="$3"
    local ENVIRONMENT="$4"
    local PHP_FPM_NAME="$5"
    local APP_NAME="$6"

    sed -i 's|access_log .*|access_log /dev/stdout;|' /etc/nginx/nginx.conf
    sed -i 's|error_log .*|error_log /dev/stderr;|' /etc/nginx/nginx.conf

    : "${CERT_DIR:?}"
    : "${DEFAULT_HOST:?}"
    : "${VIRTUAL_HOST:?}"
    : "${ENVIRONMENT:?}"
    : "${PHP_FPM_NAME:?}"
    : "${APP_NAME:?}"

    envsubst "\$DEFAULT_HOST \$CERT_DIR" </etc/nginx/templates/default.conf.template >/etc/nginx/conf.d/default.conf
    envsubst "\$VIRTUAL_HOST \$ENVIRONMENT \$PHP_FPM_NAME \$CERT_DIR \$APP_NAME" </etc/nginx/templates/laravel.conf.template >/etc/nginx/conf.d/laravel.conf
}
