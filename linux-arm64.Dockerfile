FROM hotio/dotnetcore@sha256:e95f0cbdb0d472564fd4d08d32c89165723ededa92d034116bc81252a266e43b

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libmediainfo0v5 && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://radarr.lidarr.audio/v1/update/aphrodite/changes?os=linux
ARG RADARR_VERSION=3.0.0.2415

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/aphrodite/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=arm64" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/Radarr.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
