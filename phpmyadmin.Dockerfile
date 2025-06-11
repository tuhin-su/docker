# Start from phpMyAdmin official image
FROM phpmyadmin/phpmyadmin:latest

ARG HOST_UID=1000

# Install bash, sudo, curl, git
USER root
RUN apt-get update && \
    apt-get install -y bash sudo curl git && \
    rm -rf /var/lib/apt/lists/*

# Create vscode-like user
RUN groupadd -g ${HOST_UID} vscode && \
    useradd -m -u ${HOST_UID} -g vscode -s /bin/bash vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setup application directory
RUN mkdir -p /app && \
    chown -R vscode:vscode /app

WORKDIR /app

# Switch to vscode and install Oh My Bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Switch back to root if needed
USER root

# Default CMD (can be changed based on your use case)
CMD ["apache2-foreground"]
