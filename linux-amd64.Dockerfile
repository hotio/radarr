ARG BRANCH
FROM hotio/mono:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:7878 || exit 1

COPY root/ /

# https://github.com/Radarr/Radarr/releases
ENV RADARR_VERSION=0.2.0.1358

# install app
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${RADARR_VERSION}.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"
