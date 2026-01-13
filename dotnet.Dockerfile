FROM mcr.microsoft.com/dotnet/sdk:8.0

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

# Fix Debian time validation issue
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99disable-valid-until

# Install required packages
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    nano \
    vim \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create group and user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash

# Passwordless sudo (FIXED)
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Workspace
WORKDIR /workspace

# Switch to non-root user
USER ${USERNAME}

# Keep container running
CMD ["sleep", "infinity"]
