#!/bin/bash

branch=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/radarr/radarr/pulls?state=open&base=aphrodite" | jq -r 'sort_by(.updated_at) | .[] | select((.head.repo.full_name == "Radarr/Radarr") and (.head.ref | contains("dependabot") | not)) | .head.ref' | tail -n 1)
version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/changes?os=linux" | jq -r .[0].version)
[[ -z ${version} ]] && exit 1
[[ ${version} == "null" ]] && exit 0
sed -i "s/{RADARR_VERSION=[^}]*}/{RADARR_VERSION=${version}}/g" .github/workflows/build.yml
sed -i "s/{RADARR_BRANCH=[^}]*}/{RADARR_BRANCH=${branch}}/g" .github/workflows/build.yml
echo "##[set-output name=version;]${branch}-${version}"
