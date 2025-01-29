#!/usr/bin/env bash

echo "Running entrypoint script..."
echo "Environment: $GENERAL_ENVIRONMENT"

ini_file="/usr/local/etc/php/php-ini-volume/development-php.ini"

if [ "$GENERAL_ENVIRONMENT" = "production" ]; then
    ini_file="/usr/local/etc/php/php-ini-volume/production-php.ini"
fi

echo "Using $GENERAL_ENVIRONMENT php.ini"
cp "$ini_file" /etc/php/"$PHP_FPM_VERSION"/fpm/php.ini

PHP_FPM_CONF="/etc/php/$PHP_FPM_VERSION/fpm/pool.d/www.conf"
if [ -f "$PHP_FPM_CONF" ]; then
    echo "Updating listen address and log configurations in $PHP_FPM_CONF"
    sed -i 's/listen = .*/listen = 0.0.0.0:9000/' "$PHP_FPM_CONF"
    sed -i 's/error_log = .*/error_log = \/dev\/stderr/' "$PHP_FPM_CONF"
    sed -i 's/access.log = .*/access.log = \/dev\/stdout/' "$PHP_FPM_CONF"
    sed -i 's/slowlog = .*/slowlog = \/dev\/stderr/' "$PHP_FPM_CONF"
else
    echo "Warning: $PHP_FPM_CONF not found"
fi

if [ "$GENERAL_ENVIRONMENT" = "development" ]; then
    if php-fpm -m | grep "xdebug"; then
        echo "Xdebug is enabled. Copying xdebug.ini file..."
        cp /usr/local/etc/php/php-ini-volume/xdebug.ini /etc/php/"$PHP_FPM_VERSION"/fpm/conf.d

        if [ -n "$PHP_FPM_XDEBUG_MODE" ]; then
            echo "xdebug.mode=$PHP_FPM_XDEBUG_MODE" >>/etc/php/"$PHP_FPM_VERSION"/fpm/conf.d/xdebug.ini
            echo "Xdebug mode set to '$PHP_FPM_XDEBUG_MODE'."
        else
            echo "PHP_FPM_XDEBUG_MODE is not set. Using default mode."
        fi
    else
        echo "Xdebug is not enabled."
    fi
fi

if [ -z "$1" ]; then
    echo "No command provided. Starting php-fpm by default..."
    set -- php-fpm -F
fi

echo "Starting CMD: $*"
exec "$@"
