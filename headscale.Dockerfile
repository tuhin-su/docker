FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    dpkg \
    openssh-server \
    iproute2 \
    iputils-ping \
    curl \
    sqlite3 \
    bash \
    procps \
    sysvinit-utils \
    && rm -rf /var/lib/apt/lists/*

# Download and install headscale
RUN wget -O /tmp/headscale.deb \
    https://github.com/juanfont/headscale/releases/download/v0.27.1/headscale_0.27.1_linux_amd64.deb \
    && dpkg -i /tmp/headscale.deb || apt-get -f install -y

# Create config dir
RUN mkdir -p /etc/headscale /var/lib/headscale /var/run/sshd

# SSH config
RUN ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd

# Fix config listen address and server URL using tee
RUN grep -v '^server_url:' /etc/headscale/config.yaml | \
    grep -v '^listen_addr:' | \
    tee /etc/headscale/config.yaml > /dev/null && \
    tee -a /etc/headscale/config.yaml > /dev/null <<EOF
server_url: http://0.0.0.0:80
listen_addr: 0.0.0.0:80
EOF

# Add to PATH
ENV PATH="/usr/bin:$PATH"

EXPOSE 80 22

# Start SSH + headscale as services
RUN service ssh start 
CMD ["/usr/bin/headscale", "--config", "/etc/headscale/config.yaml", "serve"]
