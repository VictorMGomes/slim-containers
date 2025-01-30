#!/usr/bin/env bash

# Execute the command from the environment variable
cd "/var/www/$GENERAL_APP_NAME" || exit 1

echo "Running command: ${NODE_START_COMMAND}"
exec ${NODE_START_COMMAND}
