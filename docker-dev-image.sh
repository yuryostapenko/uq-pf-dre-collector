#!/bin/bash

#
# This script builds docker-compose.override.yml for local environment
#


# Override default task definition compose configuration
cat <<EOT > docker-compose.override.yml
version: '3'
services:
  app:
    volumes:
      - ./:/usr/app/
      - /usr/app/node_modules
EOT

# Build
docker-compose build
