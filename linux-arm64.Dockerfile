FROM hotio/mono@sha256:728a14d6f7703bf27549edf710ea54bd108909753fa506fcbf9d2957f91f5357

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG RADARR_VERSION=0.2.0.1480

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/develop/updatefile?version=${RADARR_VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
