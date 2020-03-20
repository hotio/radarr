FROM hotio/mono@sha256:899c71346bb2ca8f1c699939b18d37e041f12efe2ad9312211da9b3335d2f4f0

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG RADARR_VERSION=0.2.0.1480

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/develop/updatefile?version=${RADARR_VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
