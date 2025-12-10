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
    tmux \
    nginx \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install headscale
RUN wget -O /tmp/headscale.deb \
    https://github.com/juanfont/headscale/releases/download/v0.27.1/headscale_0.27.1_linux_amd64.deb \
    && dpkg -i /tmp/headscale.deb || apt-get -f install -y

# Install ttyd (WebSSH)
RUN wget -O /usr/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 \
    && chmod +x /usr/bin/ttyd

# SSH setup
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd

# Headscale directories
RUN mkdir -p /etc/headscale /var/lib/headscale

# Headscale config
RUN grep -v '^server_url:' /etc/headscale/config.yaml | \
    grep -v '^listen_addr:' | \
    tee /etc/headscale/config.yaml > /dev/null && \
    tee -a /etc/headscale/config.yaml > /dev/null <<EOF
server_url: http://0.0.0.0:8080
listen_addr: 0.0.0.0:8080
EOF

# Nginx proxy → ttyd
COPY ./data/headscale/default.conf /etc/nginx/nginx.conf

# Startup script
RUN mkdir -p /root/startup && \
    cat << 'EOF' > /root/startup/start.sh
#!/bin/bash

service ssh start
service nginx start

# Start headscale
tmux new-session -d -s headscale "/usr/bin/headscale serve"

# Start WebSSH with login prompt
tmux new-session -d -s webssh "/usr/bin/ttyd -p 7681 /bin/login"

tail -f /dev/null
EOF

RUN chmod +x /root/startup/start.sh

EXPOSE 80 8080 22

CMD ["/root/startup/start.sh"]
