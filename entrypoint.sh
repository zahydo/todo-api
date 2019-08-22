#!/bin/bash
set -e

# Run migrations
bundle exec rails db:migrate

# Load pre data
bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"