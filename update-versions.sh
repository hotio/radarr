#!/bin/bash
set -exuo pipefail

version_branch="nightly"
version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${version_branch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -re '.[0].version')
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg version_branch "${version_branch}" \
    '.version = $version | .version_branch = $version_branch' <<< "${json}" | tee meta.json
