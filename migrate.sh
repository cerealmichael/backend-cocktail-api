#!/bin/sh
set -e

echo "Running database migrations..."
node ace migration:run --force

echo "Migrations completed successfully!"
