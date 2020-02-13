FROM hotio/dotnetcore@sha256:03ea5a93c0544a83e764e25aa28b347501372f813fb0f51cf901b1143538b954

ARG DEBIAN_FRONTEND="noninteractive"

ENV UNPACKERR="disabled"

EXPOSE 7878

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        mediainfo && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG UNPACKERR_VERSION=0.7.0-beta1

# install unpackerr
RUN curl -fsSL "https://github.com/davidnewhall/unpackerr/releases/download/v${UNPACKERR_VERSION}/unpackerr.arm64.linux.gz" | gunzip | dd of=/usr/local/bin/unpackerr && chmod 755 /usr/local/bin/unpackerr

ARG RADARR_VERSION=3.0.0.2615

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/aphrodite/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=arm64" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/Radarr.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
