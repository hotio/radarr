#!/bin/bash

###################
version=$(curl -fsSL "https://api.github.com/repos/radarr/radarr/releases" | jq -r .[0].tag_name | sed s/v//g)
app=RADARR
###################

location=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "${location}" || exit 1

find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG ${app}_VERSION=.*$/ARG ${app}_VERSION=${version}/g" {} \;
sed -i "s/TAG_VERSION: .*$/TAG_VERSION: ${version}/g" .drone.yml

if [[ -n "$(git status --untracked-files=no --porcelain)" ]]; then
    git add ./*.Dockerfile
    git commit -m "Updated version to: ${version}"
    echo "Updated version to: ${version}"
else
    echo "Version is still: ${version}"
fi
