ARG VERSION=bookworm
FROM redis:${VERSION}
ARG HOST_UID=1000

# Install dependencies
RUN apt update && apt install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create user and group
RUN groupadd -g ${HOST_UID} vscode \
    && useradd -m -u ${HOST_UID} -g vscode -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure Redis data directory exists and is owned by vscode
RUN mkdir -p /data && chown -R vscode:vscode /data

# Switch to vscode user
USER vscode

# Redis will read config and store data in /data
VOLUME /data
CMD ["redis-server"]
