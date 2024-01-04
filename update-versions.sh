#!/bin/bash

branch="master"
version=$(curl -fsSL "https://radarr.servarr.com/v1/update/${branch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -r .[0].version)
[[ -z ${version} ]] && exit 0
[[ ${version} == "null" ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .sbranch = "'"${branch}"'"' <<< "${version_json}" > VERSION.json
