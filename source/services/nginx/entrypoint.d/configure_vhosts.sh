#!/usr/bin/env bash

configure_vhosts() {

    local SCRIPT_PATH="/entrypoint.d/create_self-signed_cert.sh"
    chmod +x "$SCRIPT_PATH"
    # shellcheck disable=SC1090
    source "$SCRIPT_PATH"

    local NGINX_VIRTUAL_HOSTS_CONFIG="$1"
    local CERT_DIR="$2"
    local GENERAL_ENVIRONMENT="$3"
    local GENERAL_APP_NAME="$4"
    local GENERAL_SERVICES_PREFIX="$5"

    declare -A vhosts

    IFS=',' read -r -a vhost_pairs <<<"$NGINX_VIRTUAL_HOSTS_CONFIG"

    for pair in "${vhost_pairs[@]}"; do
        VIRTUAL_HOST=$(echo "$pair" | cut -d: -f1)
        TEMPLATE=$(echo "$pair" | cut -d: -f2)
        HTTP_SERVICE_NAME=$(echo "$pair" | cut -d: -f3)
        PUBLIC_PATH=$(echo "$pair" | cut -d: -f4)

        vhosts["$VIRTUAL_HOST"]="$TEMPLATE:$HTTP_SERVICE_NAME:$PUBLIC_PATH"
    done

    for VIRTUAL_HOST in "${!vhosts[@]}"; do
        TEMPLATE_HTTP_PUBLIC_PATH=${vhosts[$VIRTUAL_HOST]}
        TEMPLATE=$(echo "$TEMPLATE_HTTP_PUBLIC_PATH" | cut -d: -f1)
        HTTP_SERVICE_NAME=$(echo "$TEMPLATE_HTTP_PUBLIC_PATH" | cut -d: -f2)
        PUBLIC_PATH=$(echo "$TEMPLATE_HTTP_PUBLIC_PATH" | cut -d: -f3)

        HTTP_SERVICE_NAME="${GENERAL_SERVICES_PREFIX}_${HTTP_SERVICE_NAME}"

        export VIRTUAL_HOST GENERAL_ENVIRONMENT HTTP_SERVICE_NAME CERT_DIR GENERAL_APP_NAME PUBLIC_PATH

        envsubst "\$VIRTUAL_HOST \$GENERAL_ENVIRONMENT \$HTTP_SERVICE_NAME \$CERT_DIR \$GENERAL_APP_NAME \$PUBLIC_PATH" \
            <"/etc/nginx/templates/$TEMPLATE.conf.template" \
            >"/etc/nginx/conf.d/$VIRTUAL_HOST.conf"

        ls -l "/etc/nginx/conf.d/$VIRTUAL_HOST.conf"

        create_self_signed_cert "$CERT_DIR" "$VIRTUAL_HOST"
    done

}
