FROM hotio/mono@sha256:d4f968d114fa3403b578ea8c354d586e5e54ec05e2b8e67d18e390734973c3e6

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

# https://github.com/Radarr/Radarr/releases
ARG RADARR_VERSION=0.2.0.1450

# install app
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${RADARR_VERSION}.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
