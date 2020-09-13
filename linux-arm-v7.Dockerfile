FROM hotio/mono@sha256:1e1716dcc53fb4284c50ff73727e03534436490d17b3c76ffd77f4b82daaec2e

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG VERSION

# install app
RUN curl -fsSL "https://radarr.servarr.com/v1/update/develop/updatefile?version=${VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
