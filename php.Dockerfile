FROM  webdevops/php:8.4

USER root

# Fix APT and install required packages
RUN apt-get update || true && \
    apt-get install -y --no-install-recommends \
    sudo \
    git \
    curl \
    ca-certificates \
    bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove existing user with UID 1000 if any
RUN user_to_delete=$(getent passwd 1000 | cut -d: -f1) && \
    if [ -n "$user_to_delete" ]; then \
        echo "Deleting user $user_to_delete"; \
        userdel -r "$user_to_delete" || true; \
        rm -rf /home/"$user_to_delete"; \
    fi

# Add 'vscode' user with UID 1000
RUN useradd -m -u 1000 -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Oh My Bash for 'vscode'
RUN curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh \
    | bash -s -- --unattended && \
    cp -r /root/.oh-my-bash /home/vscode/.oh-my-bash && \
    cp /root/.bashrc /home/vscode/.bashrc && \
    chown -R vscode:vscode /home/vscode
WORKDIR /app

CMD ["sleep", "infinity"]
