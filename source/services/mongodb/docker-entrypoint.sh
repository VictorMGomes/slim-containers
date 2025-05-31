#!/bin/bash

mongod --port "$MONGO_REPLICA_PORT" --replSet rs0 --bind_ip 0.0.0.0 &
MONGOD_PID=$!

# Wait for MongoDB to be ready
until mongosh --port "$MONGO_REPLICA_PORT" --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
  echo "Waiting for MongoDB to start..."
  sleep 1
done

# Initiate replica set
INIT_REPL_CMD="rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: '$MONGO_REPLICA_HOST:$MONGO_REPLICA_PORT' }] })"
mongosh admin --port "$MONGO_REPLICA_PORT" --eval "$INIT_REPL_CMD"

# Create root user
CREATE_USER_CMD="db.createUser({ user: '$MONGO_INITDB_ROOT_USERNAME', pwd: '$MONGO_INITDB_ROOT_PASSWORD', roles: [{ role: 'root', db: 'admin' }] })"
mongosh admin --port "$MONGO_REPLICA_PORT" --eval "$CREATE_USER_CMD"

echo "REPLICA SET AND ROOT USER READY"

# Wait for MongoDB process
wait $MONGOD_PID
