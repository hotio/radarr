FROM hotio/mono@sha256:7e2a02b65395e1c5c69e91949453e096fa99dc57bb4742cd2cfcf6b0b7521a39

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG RADARR_VERSION=0.2.0.1480

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/develop/updatefile?version=${RADARR_VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
