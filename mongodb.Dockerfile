# Dockerfile.mongodb
ARG MONGO_VERSION=6.0
FROM mongo:${MONGO_VERSION}

ARG HOST_UID=1000

# Install bash, sudo, curl, git
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user with sudo and bash shell
RUN groupadd -g ${HOST_UID} vscode \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
  && usermod -aG sudo vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix permissions for data directory
RUN chown -R vscode:vscode /data/db

# Switch to vscode user and install oh-my-bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Switch back to root
USER root

# Default command to start mongod
CMD ["mongod"]
