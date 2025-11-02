#!/bin/sh
set -e

echo "Running database migrations..."
node ace migration:run --force || echo "Migration failed, continuing..."

echo "Starting server..."
node bin/server.js
