ARG VERSION=15-3.3
FROM postgis/postgis:${VERSION}

ARG HOST_UID=1000

# Install development tools
USER root
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user
RUN groupadd -g ${HOST_UID} vscode \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
  && usermod -aG sudo vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix permissions for PostgreSQL data dir
RUN mkdir -p /var/lib/postgresql /var/run/postgresql \
    && chown -R vscode:vscode /var/lib/postgresql /var/run/postgresql

# Switch to vscode user
USER vscode

# Optional: oh-my-bash for dev
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Set environment variables for init
ENV POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    POSTGRES_DB=gis

# Expose default PostgreSQL port
EXPOSE 5432

# Default command (PostgreSQL server)
CMD ["docker-entrypoint.sh", "postgres"]
