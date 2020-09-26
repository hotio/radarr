FROM hotio/mono@sha256:8304ecdb28c045fa2768ccf8d1f061b53bc8ebd921c6db755d5bc602bc5cb528

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

ARG VERSION

# install app
RUN curl -fsSL "https://radarr.servarr.com/v1/update/develop/updatefile?version=${VERSION}&os=linux&runtime=mono" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    rm -rf "${APP_DIR}/NzbDrone.Update" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
