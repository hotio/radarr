FROM hotio/mono@sha256:eb658649d158322ab76db26001b0a678fa148f3a948afbe7963589083b788ea3

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 7878

# https://github.com/Radarr/Radarr/releases
ARG RADARR_VERSION=0.2.0.1450

# install app
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${RADARR_VERSION}.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
