FROM debian:bookworm-slim

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    tar \
    zip \
    unzip \
    build-essential \
    cmake \
    pkg-config \
    ninja-build \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install vcpkg globally in /opt
ENV VCPKG_FORCE_SYSTEM_BINARIES=1
RUN git clone https://github.com/microsoft/vcpkg.git /opt/vcpkg && \
    /opt/vcpkg/bootstrap-vcpkg.sh && \
    chmod -R a+rX /opt/vcpkg

# Add vcpkg to PATH for all users
ENV PATH="/opt/vcpkg:${PATH}"

# Create non-root user with UID 1000 (for VSCode Remote Containers)
RUN useradd -ms /bin/bash vscode && \
    usermod -u 1000 vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER vscode
WORKDIR /home/vscode

# Install Oh My Bash for the vscode user
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

CMD ["sleep", "infinity"]
