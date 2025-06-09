FROM nginx:latest
ARG HOST_UID=1000

RUN apt-get update && apt-get install -y \
    bash sudo curl git \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${HOST_UID} vscode \
    && useradd -m -u ${HOST_UID} -g vscode -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
USER root

CMD ["nginx", "-g", "daemon off;"]
