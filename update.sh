#!/bin/bash

if [[ ${1} == "screenshot" ]]; then
    SERVICE_IP="http://$(ping -c1 -4 service | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p'):7878/system/status"
    NETWORK_IDLE="2"
    cd /usr/src/app && node <<EOF
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    bindAddress: "0.0.0.0",
    args: [
      "--no-sandbox",
      "--headless",
      "--disable-gpu",
      "--disable-dev-shm-usage",
      "--remote-debugging-port=9222",
      "--remote-debugging-address=0.0.0.0"
    ]
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1920, height: 1080 });
  try {
    await page.goto("${SERVICE_IP}", { waitUntil: "networkidle${NETWORK_IDLE}" });
  } catch (e) {
    console.log(e)
    process.exit(1)
  }
  await page.evaluate(() => {
    const div = document.createElement('div');
    div.innerHTML = 'Image: ${DRONE_REPO_OWNER}/${DRONE_REPO_NAME##docker-}:${DRONE_COMMIT_BRANCH}<br>Commit: ${DRONE_COMMIT_SHA:0:7}<br>Build: #${DRONE_BUILD_NUMBER}<br>Timestamp: $(date -u --iso-8601=seconds)';
    div.style.cssText = "all: initial !important; border-radius: 4px !important; font-weight: normal !important; font-size: normal !important; font-family: monospace !important; padding: 10px !important; color: black !important; position: fixed !important; bottom: 10px !important; right: 10px !important; background-color: #e7f3fe !important; border-left: 6px solid #2196F3 !important; z-index: 10000 !important";
    document.body.appendChild(div);
  });
  await page.screenshot({ path: "/drone/src/screenshot.png", fullPage: true });
  await browser.close();
})();
EOF
elif [[ ${1} == "checkservice" ]]; then
    SERVICE="http://service:7878"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL ${SERVICE} > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    curl -fsSL ${SERVICE} > /dev/null
else
    branch=$(curl -fsSL "https://api.github.com/repos/radarr/radarr/pulls?state=open&base=aphrodite" | jq -r 'sort_by(.updated_at) | .[] | select(.head.repo.full_name == "Radarr/Radarr") | .head.ref' | tail -n 1)
    branch=custom-formats-2
    version=$(curl -fsSL "https://radarr.lidarr.audio/v1/update/${branch}/changes?os=linux" | jq -r .[0].version)
    [[ -z ${version} ]] && exit 1
    find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG RADARR_VERSION=.*$/ARG RADARR_VERSION=${version}/g" {} \;
    find . -type f -name '*.Dockerfile' -exec sed -i "s/ARG RADARR_BRANCH=.*$/ARG RADARR_BRANCH=${branch}/g" {} \;
    sed -i "s/{TAG_VERSION=.*}$/{TAG_VERSION=${branch}-${version}}/g" .drone.yml
    sed -i "s/{TAG_BRANCH=.*}$/{TAG_BRANCH=${branch}}/g" .drone.yml
    echo "##[set-output name=version;]${branch}-${version}"
fi
