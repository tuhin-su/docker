# Base image
ARG VERSION=latest
FROM dpage/pgadmin4:${VERSION}

ARG HOST_UID=1000

USER root

USER pgadmin
