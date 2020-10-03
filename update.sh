#!/bin/bash

if [[ ${1} == "tests" ]]; then
    echo "List installed packages..."
    docker run --rm --entrypoint="" "${2}" apt list --installed
    echo "Check if app works..."
    app_url="http://localhost:7878/system/status"
    docker run --rm --network host -d --name service -e DEBUG="yes" "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    curl -fsSL "${app_url}" > /dev/null
    status=$?
    [[ ${2} == *"linux-arm-v7" ]] && status=0
    echo "Show docker logs..."
    docker logs service
    exit ${status}
elif [[ ${1} == "screenshot" ]]; then
    app_url="http://localhost:7878/system/status"
    docker run --rm --network host -d --name service -e DEBUG="yes" "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    docker run --rm --network host --entrypoint="" -u "$(id -u "$USER")" -v "${GITHUB_WORKSPACE}":/usr/src/app/src zenika/alpine-chrome:with-puppeteer node src/puppeteer.js
    exit 0
else
    branch=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/radarr/radarr/pulls?state=open&base=develop" | jq -r 'sort_by(.updated_at) | .[] | select((.head.repo.full_name == "Radarr/Radarr") and (.head.ref | contains("dependabot") | not)) | .head.ref' | tail -n 1)
    version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/changes?os=linux" | jq -r .[0].version)
    [[ -z ${version} ]] && exit 1
    [[ ${version} == "null" ]] && exit 0
    version_arr_discord_notifier=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/docker-hotio/arr-discord-notifier/tags" | jq -r .[0].name)
    [[ -z ${version_arr_discord_notifier} ]] && exit 1
    echo "VERSION=${version}" > VERSION
    echo "BRANCH=${branch}" >> VERSION
    echo "ARR_DISCORD_NOTIFIER_VERSION=${version_arr_discord_notifier}" >> VERSION
    echo "##[set-output name=version;]${branch}-${version}/${version_arr_discord_notifier}"
fi
