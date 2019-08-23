#!/bin/bash
set -e
# Setup database for first time
bundle exec rails db:setup

# Run migrations
bundle exec rails db:migrate

# Load pre data
bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"