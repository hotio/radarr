FROM hotio/mono@sha256:54413d909a2186ef4e5045eca8612a54d3d88a1f390a71b3ee33e637c4e990ed

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG RADARR_VERSION

# install app
RUN curl -fsSL "https://radarr.servarr.com/v1/update/develop/updatefile?version=${RADARR_VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
