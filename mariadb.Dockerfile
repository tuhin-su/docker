# Use build arg to define MariaDB version (defaults to latest)
ARG VERSION=latest
FROM mariadb:${VERSION}


ARG HOST_UID=1000

# Install bash, sudo, curl, git
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*