FROM hotio/mono@sha256:7794be1032777eb0e81b3f1c888c555b6777b1542733a167fc84689755980bfb

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

# https://github.com/Radarr/Radarr/releases
ARG RADARR_VERSION=0.2.0.1450

# install app
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${RADARR_VERSION}.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
