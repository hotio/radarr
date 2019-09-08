FROM hotio/mono

ARG DEBIAN_FRONTEND="noninteractive"
ARG GIT_COMMIT
ARG GIT_TAG
ARG ARCH

ENV GIT_COMMIT="${GIT_COMMIT}" GIT_TAG="${GIT_TAG}" ARCH="${ARCH}"
ENV APP="Radarr"
EXPOSE 7878
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:7878 || exit 1

# install app
# https://github.com/Radarr/Radarr/releases
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v0.2.0.1358/Radarr.develop.0.2.0.1358.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
