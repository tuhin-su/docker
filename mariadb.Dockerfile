ARG VERSION=11.4
FROM mariadb:${VERSION}

ARG HOST_UID=1000

# Install required packages
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user with desired UID
RUN groupadd -g ${HOST_UID} vscode \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
  && usermod -aG sudo vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure MariaDB data and config dirs exist with proper permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
  && chown -R vscode:vscode /var/lib/mysql /var/run/mysqld

# Switch to vscode user
USER vscode

# Optional: install oh-my-bash (for dev container use)
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Set environment variables
ENV HOME=/home/vscode \
    MYSQL_ROOT_PASSWORD=root \
    MYSQL_DATABASE=devdb \
    MYSQL_USER=devuser \
    MYSQL_PASSWORD=devpass

# Expose default MariaDB port
EXPOSE 3306

# Run MariaDB as vscode user
CMD ["mysqld"]
