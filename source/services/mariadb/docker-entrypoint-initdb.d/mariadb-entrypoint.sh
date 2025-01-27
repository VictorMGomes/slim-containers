#!/usr/bin/env bash

setup_root_password() {
    if ! mariadb --user=root --password="$MYSQL_ROOT_PASSWORD" -e "QUIT" 2>/dev/null; then
        mariadb --user=root --password=root <<-EOSQL
            SET PASSWORD FOR 'root'@'$MYSQL_ROOT_HOST' = PASSWORD('$MYSQL_ROOT_PASSWORD');
            FLUSH PRIVILEGES;
EOSQL
    fi
}

setup_root_access() {
    if ! mariadb --user=root --password="$MYSQL_ROOT_PASSWORD" -e "SELECT Host FROM mysql.user WHERE User='root' AND Host='$MYSQL_ROOT_HOST';" 2>/dev/null; then
        mariadb --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
            UPDATE mysql.user SET Host='$MYSQL_ROOT_HOST' WHERE User='root';
            FLUSH PRIVILEGES;
EOSQL
    fi
}

setup_user_db() {
    mariadb --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'$MYSQL_USER_HOST' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT $MYSQL_USER_PRIVILEGES ON $MYSQL_USER_PRIVILEGES_TARGET TO '$MYSQL_USER'@'$MYSQL_USER_HOST' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOSQL
}

setup_root_password
setup_root_access
setup_user_db
