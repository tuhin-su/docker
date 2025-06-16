FROM node:lts-alpine

ARG HOST_UID=1000
ARG VERSION=latest
ENV CHROME_BIN='/usr/bin/chromium-browser'

# Install bash, curl, git, sudo
RUN apk add --no-cache bash curl git sudo

# Set up user and shell
RUN deluser --remove-home node \
  && addgroup -S vscode -g ${HOST_UID} \
  && adduser -S -G vscode -u ${HOST_UID} -s /bin/bash vscode \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && addgroup vscode wheel

# Set workdir
WORKDIR /app

# Install Angular CLI
RUN npm install -g npm@${NG_VERSION} @angular/cli

# Switch to vscode user for Oh My Bash install
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Switch back to root (optional)
USER root

# Default command
CMD ["sleep", "infinity"]
