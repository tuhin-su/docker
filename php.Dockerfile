FROM webdevops/php-apache:latest

# Remove any existing user with UID 1000
RUN existing_user=$(getent passwd 1000 | cut -d: -f1) && \
    if [ -n "$existing_user" ]; then \
        echo "Removing user $existing_user with UID 1000"; \
        userdel -r "$existing_user" || true; \
        rm -rf /home/"$existing_user"; \
    fi

# Create user 'vscode' with UID 1000 and home directory
RUN useradd -m -u 1000 -s /bin/bash vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install sudo and git (required for oh-my-bash)
RUN apt-get update && apt-get install -y sudo git curl

# Install Oh My Bash for vscode
RUN curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh | bash -s -- --unattended && \
    cp -r /root/.oh-my-bash /home/vscode/.oh-my-bash && \
    cp /root/.bashrc /home/vscode/.bashrc && \
    chown -R vscode:vscode /home/vscode

# Set working directory
WORKDIR /app

CMD [ "sleep", 'infinity' ]
