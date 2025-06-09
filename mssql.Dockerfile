# Use ARG before FROM to allow dynamic base image version
ARG MSSQL_VERSION=2022-latest
FROM mcr.microsoft.com/mssql/server:${MSSQL_VERSION}

ARG HOST_UID=1000
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer
ENV MSSQL_USER=vscode
ENV MSSQL_UID=${HOST_UID}

# Install bash, sudo, curl, etc.
USER root
RUN apt-get update && apt-get install -y bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

# Add a dev user
RUN groupadd -g ${MSSQL_UID} vscode \
    && useradd -m -s /bin/bash -u ${MSSQL_UID} -g vscode vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Oh My Bash for vscode
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Return to root for server start
USER root

CMD ["/opt/mssql/bin/sqlservr"]
