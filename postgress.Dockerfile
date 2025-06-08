# Use build arg to choose the PostgreSQL version (default to latest)
ARG POSTGRES_VERSION=latest
FROM postgres:${POSTGRES_VERSION}

ARG HOST_UID=1000

# Install required packages
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with bash shell and sudo privileges
RUN groupadd -g ${HOST_UID} vscode \
    && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
    && usermod -aG sudo vscode \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change ownership of PostgreSQL data directories to vscode
RUN chown -R vscode:vscode /var/lib/postgresql \
    && chown -R vscode:vscode /var/run/postgresql \
    && chown -R vscode:vscode /etc/postgresql || true

# Set working directory
WORKDIR /app

# Install Oh My Bash for vscode user
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Switch back to root to run PostgreSQL
USER root

# Default command
CMD ["postgres"]
