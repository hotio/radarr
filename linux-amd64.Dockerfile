FROM ghcr.io/hotio/base@sha256:1a0aa67c51aa3789f3453e7d0e000149ac67dc1f6bb9173d4ee6243cc83597ce

EXPOSE 7878

RUN apk add --no-cache libintl sqlite-libs icu-libs && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main tinyxml2 && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community libmediainfo=21.09-r0

ARG VERSION
ARG PACKAGE_VERSION=${VERSION}
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://radarr.servarr.com/v1/update/nightly/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Radarr.Update" && \
    echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=nightly" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

ARG ARR_DISCORD_NOTIFIER_VERSION
RUN curl -fsSL "https://raw.githubusercontent.com/hotio/arr-discord-notifier/${ARR_DISCORD_NOTIFIER_VERSION}/arr-discord-notifier.sh" > "${APP_DIR}/arr-discord-notifier.sh" && \
    chmod u=rwx,go=rx "${APP_DIR}/arr-discord-notifier.sh"

COPY root/ /
