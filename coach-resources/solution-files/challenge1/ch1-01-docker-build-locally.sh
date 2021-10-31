#!/bin/bash

# Build POI (dotnet)
pushd src/poi
docker build \
    -f ../../dockerfiles/Dockerfile_3 \
    -t "tripinsights/poi:1.0" \
    --no-cache \
    --build-arg IMAGE_VERSION="1.0" \
    --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" \
    --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
    .
popd

# Build Trips (go)
pushd src/trips
docker build \
    -f ../../dockerfiles/Dockerfile_4 \
    -t "tripinsights/trips:1.0" \
    --no-cache \
    --build-arg IMAGE_VERSION="1.0" \
    --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" \
    --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
    .
popd

# Build TripViewer (dotnet)
pushd src/tripviewer
docker build \
    -f ../../dockerfiles/Dockerfile_1 \
    -t "tripinsights/tripviewer:1.0" \
    --no-cache \
    --build-arg IMAGE_VERSION="1.0" \
    --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" \
    --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
    .
popd

# Build User-Java (java)
pushd src/user-java
docker build \
    -f ../../dockerfiles/Dockerfile_0 \
    -t "tripinsights/user-java:1.0" \
    --no-cache \
    --build-arg IMAGE_VERSION="1.0" \
    --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" \
    --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
    .
popd

# Build Userprofile (node)
pushd src/userprofile
docker build \
    -f ../../dockerfiles/Dockerfile_2 \
    -t "tripinsights/userprofile:1.0" \
    --no-cache \
    --build-arg IMAGE_VERSION="1.0" \
    --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" \
    --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
    .
popd
