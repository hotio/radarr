#!/bin/bash

branch=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/radarr/radarr/pulls?state=open&base=develop" | jq -r 'sort_by(.updated_at) | .[] | select((.head.repo.full_name == "Radarr/Radarr") and (.head.ref | contains("dependabot") | not)) | .head.ref' | tail -n 1)
[[ -z ${branch} ]] && exit 0
version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -r .[0].version)
[[ -z ${version} ]] && exit 0
[[ ${version} == "null" ]] && exit 0
version_arr_discord_notifier=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/hotio/arr-discord-notifier/tags" | jq -r .[0].name)
[[ -z ${version_arr_discord_notifier} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .branch = "'"${branch}"'" | .arr_discord_notifier_version = "'"${version_arr_discord_notifier}"'"' <<< "${version_json}" > VERSION.json
