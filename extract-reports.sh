#!/bin/bash

# Build test stage and extract reports
docker build --target test -t python-app-test .

# Create container and copy reports
docker create --name temp-container python-app-test
docker cp temp-container:/app/coverage-report ./coverage-report
docker rm temp-container

echo "Test reports extracted to ./coverage-report/"