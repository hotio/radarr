FROM hotio/mono

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:7878 || exit 1

COPY root/ /

# install app
RUN version=$(sed -n '1p' /versions/radarr) && \
    curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"
