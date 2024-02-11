#!/bin/bash
json=$(cat VERSION.json)
upstream_image=$(jq -re '.upstream_image' <<< "${json}")
upstream_tag=$(jq -re '.upstream_tag' <<< "${json}")
if [[ ${upstream_image} == *"hotio/base" ]]; then
    upstream_tag="${upstream_tag}-$(curl -fsSL "https://raw.githubusercontent.com${upstream_image//ghcr.io/}/${upstream_tag}/VERSION.json" | jq -re '.version')" || exit 1
fi
manifest=$(skopeo inspect --raw "docker://${upstream_image}:${upstream_tag}") || exit 1
upstream_digest_amd64=$(jq -re '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest' <<< "${manifest}")
upstream_digest_arm64=$(jq -re '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest' <<< "${manifest}")
jq --sort-keys \
    --arg upstream_digest_amd64 "${upstream_digest_amd64}" \
    --arg upstream_digest_arm64 "${upstream_digest_arm64}" \
    '.upstream_digest_amd64 = $upstream_digest_amd64 | .upstream_digest_arm64 = $upstream_digest_arm64' <<< "${json}" | tee VERSION.json

[[ -f update-self-version.sh ]] && bash ./update-self-version.sh
