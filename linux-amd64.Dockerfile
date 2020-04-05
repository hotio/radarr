FROM hotio/dotnetcore:focal

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

ARG RADARR_VERSION=3.0.0.2788
ARG RADARR_BRANCH=process-downloads-seperate

# install app
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://radarr.lidarr.audio/v1/update/${RADARR_BRANCH}/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Radarr.Update" && \
    echo "PackageVersion=${RADARR_VERSION}\nPackageAuthor=hotio\nUpdateMethod=Docker\nBranch=${RADARR_BRANCH}" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
