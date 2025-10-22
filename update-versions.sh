#!/bin/bash
branch=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/radarr/radarr/pulls?state=open&sort=updated&direction=desc" | jq -re '[.[] | select((.head.repo.full_name == "Radarr/Radarr") and (.head.ref | contains("dependabot") | not) and (.base.ref == "develop")) | .head.ref][0]') || exit 1
version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -re '.[0].version') || exit 1
curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/updatefile?version=${version}&os=linuxmusl&runtime=netcore&arch=x64" -o /dev/null || exit 1
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg branch "${branch}" \
    '.version = $version | .branch = $branch' <<< "${json}" | tee VERSION.json
