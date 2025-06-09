# Use build arg to select Node version (defaults to lts-alpine)
ARG VERSION=lts-alpine
FROM node:${VERSION}

ARG HOST_UID=1000

ENV CHROME_BIN='/usr/bin/chromium-browser'

# Install bash, sudo, curl, git
RUN apk add --no-cache bash sudo curl git

# Create a new user with bash shell and sudo access
RUN deluser --remove-home node \
  && addgroup -S vscode -g ${HOST_UID} \
  && adduser -S -G vscode -u ${HOST_UID} -s /bin/bash vscode \
  && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && addgroup vscode wheel

# Set ownership of common dev folders to the vscode user
RUN mkdir -p /app \
  && chown -R vscode:vscode /app \
  && chown -R vscode:vscode /usr/local/lib/node_modules

# Set working directory
WORKDIR /app

# Switch to vscode user and install Oh My Bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Switch back to root if needed
USER root

# Default CMD
CMD ["sleep", "infinity"]
