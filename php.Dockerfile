# Dockerfile.php
ARG PHP_VERSION=8.2-cli
FROM php:${PHP_VERSION}

ARG HOST_UID=1000
ARG COMPOSER_VERSION=latest

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

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=${COMPOSER_VERSION} \
  && mv composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer

# Set working directory and permissions
WORKDIR /app/php
RUN chown -R vscode:vscode /app/php

# Switch to vscode user and install Oh My Bash
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
USER root
# Default command
CMD ["sleep", "infinity"]
