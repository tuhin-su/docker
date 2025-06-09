# Use build arg to define MariaDB version (defaults to latest)
ARG VERSION=latest
FROM mariadb:${VERSION}

ARG HOST_UID=1000

# Install bash, sudo, curl, git
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create a new user with bash shell and sudo access
RUN if ! getent group vscode > /dev/null; then \
        groupadd -g ${HOST_UID} vscode; \
    fi && \
    if ! id -u vscode > /dev/null 2>&1; then \
        useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode; \
    fi && \
    usermod -aG sudo vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Change ownership of important directories to HOST_UID
RUN chown -R vscode:vscode /var/lib/mysql \
    && chown -R vscode:vscode /var/log/mysql || true \
    && chown -R vscode:vscode /etc/mysql || true

# Switch back to root (MariaDB still needs root or mysql user for startup)
USER root
