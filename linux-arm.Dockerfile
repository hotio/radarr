FROM hotio/dotnetcore@sha256:58634feb841d0892fb38d8841506ee5517d6a400d079b140c35f7852bf68026d

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

ARG RADARR_VERSION=3.0.0.2665

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/aphrodite/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=arm" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/Radarr.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
