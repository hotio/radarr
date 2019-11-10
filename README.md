# radarr

[![GitHub](https://img.shields.io/badge/source-github-lightgrey?style=flat-square)](https://github.com/hotio/docker-radarr)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/radarr?style=flat-square)](https://hub.docker.com/r/hotio/radarr)
[![Drone (cloud)](https://img.shields.io/drone/build/hotio/docker-radarr?style=flat-square)](https://cloud.drone.io/hotio/docker-radarr)

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
-e VERSION=image
```

Possible values for `VERSION`:

```shell
VERSION=image
VERSION=stable
VERSION=unstable
VERSION=https://github.com/Radarr/Radarr/releases/download/v0.2.0.1120/Radarr.develop.0.2.0.1120.linux.tar.gz
VERSION=file:///config/Radarr.develop.0.2.0.1120.linux.tar.gz
```

## Tags

| Tag       | Description                             |
| ----------|-----------------------------------------|
| latest    | Stable version                          |
| master    | Stable version                          |
| aphrodite | Unstable version, new UI like Sonarr V3 |

You can also find tags that reference a commit or version number.

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```
