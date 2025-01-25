#!/usr/bin/env bash

create_self_signed_cert() {
    local CERT_DIR="$1"
    local DEFAULT_HOST="$2"
    local VIRTUAL_HOST="$3"

    local DEFAULT_KEY_FILE="${CERT_DIR}/${DEFAULT_HOST}.key"
    local DEFAULT_CERT_FILE="${CERT_DIR}/${DEFAULT_HOST}.crt"
    local VIRTUAL_KEY_FILE="${CERT_DIR}/${VIRTUAL_HOST}.key"
    local VIRTUAL_CERT_FILE="${CERT_DIR}/${VIRTUAL_HOST}.crt"

    mkdir -p "$CERT_DIR"

    create_certificates() {
        local HOST_KEY_FILE="$1"
        local HOST_CERT_FILE="$2"
        local HOST_NAME="$3"

        if [ ! -f "$HOST_CERT_FILE" ] || [ ! -f "$HOST_KEY_FILE" ]; then
            echo "Creating self-signed certificate for $HOST_NAME..."

            openssl req -x509 -nodes -newkey rsa:2048 -keyout "$HOST_KEY_FILE" -out "$HOST_CERT_FILE" -days 365 \
                -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=$HOST_NAME"

            echo "Self-signed certificate and key created for $HOST_NAME at $CERT_DIR"
        else
            echo "Certificate and key already exist for $HOST_NAME. Skipping creation."
        fi
    }

    create_certificates "$DEFAULT_KEY_FILE" "$DEFAULT_CERT_FILE" "$DEFAULT_HOST"
    create_certificates "$VIRTUAL_KEY_FILE" "$VIRTUAL_CERT_FILE" "$VIRTUAL_HOST"
}
