#!/bin/bash

version=$(curl -fsSL "https://radarr.lidarr.audio/v1/update/aphrodite/changes?os=linux" | jq -r .[0].version)
find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG RADARR_VERSION=.*$/ARG RADARR_VERSION=${version}/g" {} \;
sed -i "s/{TAG_VERSION=.*}$/{TAG_VERSION=${version}}/g" .drone.yml
echo "##[set-output name=version;]${version}"
