ARG VERSION=2022-latest
FROM mcr.microsoft.com/mssql/server:${VERSION}

ARG HOST_UID=1000

# Install required tools
USER root
RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user
RUN groupadd -g ${HOST_UID} vscode \
    && useradd -m -u ${HOST_UID} -g vscode -s /bin/bash vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix permissions for SQL Server directories
RUN mkdir -p /var/opt/mssql \
    && chown -R vscode:vscode /var/opt/mssql

# Set required ENV for SQL Server
ENV ACCEPT_EULA=Y \
    MSSQL_PID=Express \
    MSSQL_USER=vscode \
    MSSQL_PASSWORD=MyStrong@Pass123 \
    MSSQL_DATA_DIR=/var/opt/mssql/data \
    MSSQL_LOG_DIR=/var/opt/mssql/log \
    MSSQL_BACKUP_DIR=/var/opt/mssql/backup

# Expose SQL Server port
EXPOSE 1433

# Switch to vscode user
USER vscode

# Optional: install oh-my-bash for dev experience
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Start SQL Server
CMD ["/opt/mssql/bin/sqlservr"]
