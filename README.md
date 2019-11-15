# radarr

[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-radarr)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/radarr)](https://hub.docker.com/r/hotio/radarr)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name radarr -p 7878:7878 -v /tmp/radarr:/config -e TZ=Etc/UTC hotio/radarr
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=022
```

## Tags

| Tag       | Description                             | Build Status                                                                                                                                             | Last Updated                                                                                            |
| ----------|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| latest    | The same as `stable`                    |                                                                                                                                                          |                                                                                                         |
| stable    | Stable version                          | [![Build Status](https://cloud.drone.io/api/badges/hotio/docker-radarr/status.svg?ref=refs/heads/stable)](https://cloud.drone.io/hotio/docker-radarr)    | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/hotio/docker-radarr/stable)    |
| unstable  | Unstable version                        | [![Build Status](https://cloud.drone.io/api/badges/hotio/docker-radarr/status.svg?ref=refs/heads/unstable)](https://cloud.drone.io/hotio/docker-radarr)  | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/hotio/docker-radarr/unstable)  |
| aphrodite | Unstable version, new UI like Sonarr V3 | [![Build Status](https://cloud.drone.io/api/badges/hotio/docker-radarr/status.svg?ref=refs/heads/aphrodite)](https://cloud.drone.io/hotio/docker-radarr) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/hotio/docker-radarr/aphrodite) |

You can also find tags that reference a commit or version number.

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```
