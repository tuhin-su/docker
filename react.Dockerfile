# Dockerfile.react
ARG NODE_VERSION=20-alpine
FROM node:${NODE_VERSION}

ARG HOST_UID=1000

RUN apk add --no-cache bash sudo curl git

# REMOVE NODE USER
RUN deluser --remove-home node

# CREATE NEW USER
RUN addgroup -g ${HOST_UID} vscode \
  && adduser -D -u ${HOST_UID} -G vscode -s /bin/bash vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /app/react
RUN chown -R vscode:vscode /app/react

USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
USER root
CMD ["sleep", "infinity"]
