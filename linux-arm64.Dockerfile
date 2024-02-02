ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 7878
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS}

RUN apk add --no-cache libintl sqlite-libs icu-libs

ARG VERSION
ARG BRANCH
ARG PACKAGE_VERSION={VERSION}
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://radarr.servarr.com/v1/update/${BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=arm64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Radarr.Update" && \
    echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=${BRANCH}" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
