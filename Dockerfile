FROM hotio/mono

ARG DEBIAN_FRONTEND="noninteractive"
ARG COMMIT
ARG TAG

ENV COMMIT="${COMMIT}" TAG="${TAG}"
ENV APP="Radarr"
EXPOSE 7878
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:7878 || exit 1

# install app
# https://github.com/Radarr/Radarr/releases
RUN curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v0.2.0.1358/Radarr.develop.0.2.0.1358.linux.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
