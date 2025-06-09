# Dockerfile.php
ARG VERSION=8.2-cli
FROM php:${VERSION}

ARG HOST_UID=1000

# Install required packages and PHP extensions
RUN apt update && apt install -y \
    bash sudo curl git unzip zip libpng-dev libonig-dev libzip-dev libicu-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip gd intl bcmath opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Create a non-root user with sudo
RUN groupadd -g ${HOST_UID} vscode \
  && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
  && usermod -aG sudo vscode \
  && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Composer (fixed)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Set working directory and permissions
WORKDIR /app
RUN chown -R vscode:vscode /app

# Switch to vscode user and install Oh My Bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
USER root
# Default command
CMD ["sleep", "infinity"]
