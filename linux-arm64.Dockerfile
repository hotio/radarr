FROM hotio/base@sha256:5c748f472fd4dda9c2332dbce09046f9b419d6776083ec17df1d4d8370eb5a0b

EXPOSE 7878

RUN apk add --no-cache libintl libmediainfo sqlite-libs icu-libs

ARG RADARR_VERSION
ARG PACKAGE_VERSION=${RADARR_VERSION}

# install app
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://radarr.servarr.com/v1/update/musl/updatefile?os=linuxmusl&runtime=netcore&arch=arm64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Radarr.Update" && \
    echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=aphrodite" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
