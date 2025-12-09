#!/bin/bash
set -e
# Wait for volume to be mounted and install dependencies
if [ -f "package.json" ]; then
    echo "Volume mounted, installing dependencies..."
    cd /app/backstage
    yarn start
else
    echo "No package.json found. Volume not mounted?"
    exit 1
fi