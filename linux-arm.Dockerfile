FROM hotio/mono@sha256:4e8435a70225d3011fb66b23ee18b14a9a4e1fb14d6309f3b315f6469c999c42

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG RADARR_VERSION=0.2.0.1450

# install app
RUN curl -fsSL "https://radarr.lidarr.audio/v1/update/develop/updatefile?version=${RADARR_VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
