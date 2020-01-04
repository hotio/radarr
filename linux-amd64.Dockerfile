FROM hotio/dotnetcore@sha256:6f4d3df91a80f5cbb6f2ef0a54ef4c0f38cf4cac0a6bb66cbb7e550f092a7881

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        mediainfo && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG RADARR_VERSION=3.0.0.2458

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/aphrodite/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/Radarr.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
