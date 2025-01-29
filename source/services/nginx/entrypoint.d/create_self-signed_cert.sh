#!/usr/bin/env bash

create_self_signed_cert() {
    local CERT_DIR="$1"
    local HOST="$2"

    local KEY_FILE="${CERT_DIR}/${HOST}.key"
    local CERT_FILE="${CERT_DIR}/${HOST}.crt"

    mkdir -p "$CERT_DIR"

    if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
        echo "Creating self-signed certificate for $HOST..."

        openssl req -x509 -nodes -newkey rsa:2048 -keyout "$KEY_FILE" -out "$CERT_FILE" -days 365 \
            -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=$HOST"

        echo "Self-signed certificate and key created for $HOST at $CERT_DIR"
        ls -l "$KEY_FILE"
        ls -l "$CERT_FILE"
    else
        echo "Certificate and key already exist for $HOST. Skipping creation."
        ls -l "$KEY_FILE"
        ls -l "$CERT_FILE"
    fi
}
