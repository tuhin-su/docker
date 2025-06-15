# Base image
ARG VERSION=latest
FROM dpage/pgadmin4:${VERSION}

ARG HOST_UID=1000

USER root

# Use apk (Alpine package manager) to install packages
RUN apk update && apk add --no-cache \
    bash sudo curl git

USER pgadmin
