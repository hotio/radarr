#!/bin/bash

version=$(curl -fsSL "https://radarr.servarr.com/v1/update/master/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -r .[0].version)
[[ -z ${version} ]] && exit 0
[[ ${version} == "null" ]] && exit 0
version_arr_discord_notifier=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/hotio/arr-discord-notifier/tags" | jq -r .[0].name)
[[ -z ${version_arr_discord_notifier} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .arr_discord_notifier_version = "'"${version_arr_discord_notifier}"'"' <<< "${version_json}" > VERSION.json
