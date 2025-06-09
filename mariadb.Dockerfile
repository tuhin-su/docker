# Use build arg to define MariaDB version (defaults to latest)
ARG VERSION=latest
FROM mariadb:${VERSION}


ARG HOST_UID=1000

# Install bash, sudo, curl, git
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

RUN getent group vscode || groupadd -g ${HOST_UID} vscode \
    && id -u vscode >/dev/null 2>&1 || useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
    && usermod -aG sudo vscode \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode


# Change ownership of important directories to HOST_UID
RUN chown -R vscode:vscode /var/lib/mysql \
    && chown -R vscode:vscode /var/log/mysql || true \
    && chown -R vscode:vscode /etc/mysql || true
USER vscode
