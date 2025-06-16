# Dockerfile.mongodb
ARG VERSION=6.0
FROM mongo:${VERSION}

ARG HOST_UID=1000

# Install necessary tools
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd -g ${HOST_UID} vscode \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
  && usermod -aG sudo vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure MongoDB data dir exists with correct permissions
RUN mkdir -p /data/db /data/configdb \
    && chown -R vscode:vscode /data /data/db /data/configdb

# Switch to vscode user
USER vscode

# Install oh-my-bash (suppress prompts)
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Set environment variable to allow mongod to run without root
ENV HOME=/home/vscode

# Run mongod as vscode user
CMD ["mongod", "--dbpath", "/data/db"]
