FROM node:lts-alpine

ARG HOST_UID=1000
ARG NG_VERSION=latest

ENV CHROME_BIN="/usr/bin/chromium-browser"
ENV NPM_CONFIG_PREFIX=/home/vscode/.npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

# System dependencies
RUN apk update && apk add --no-cache \
  bash \
  curl \
  git \
  sudo \
  chromium \
  nss \
  udev \
  ttf-freefont \
  libc6-compat \
  dumb-init \
  make \
  g++ \
  python3 \
  shadow \
  libstdc++ \
  yarn \
  && rm -rf /var/cache/apk/*

# Create non-root user: vscode
RUN deluser node || true \
  && addgroup -g ${HOST_UID} vscode \
  && adduser -u ${HOST_UID} -G vscode -s /bin/bash -D vscode \
  && echo 'vscode ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Create app directory and give ownership
WORKDIR /app
RUN chown -R vscode:vscode /app

# Install Angular CLI globally
RUN npm install -g @angular/cli@${NG_VERSION}

# Switch to vscode user and install Oh My Bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

# Use dumb-init as the default init system (handles signals better)
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Default command (can be overridden in docker-compose or CLI)
CMD ["sleep", "infinity"]
