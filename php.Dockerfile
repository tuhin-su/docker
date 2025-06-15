ARG VERSION=latest
FROM php:${VERSION}

ARG HOST_UID=1000

# --- SYSTEM DEPENDENCIES ---
RUN apt update && apt install -y \
    bash sudo curl git unzip zip \
    libpng-dev libonig-dev libzip-dev libicu-dev libxml2-dev libpq-dev \
    postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- PHP EXTENSIONS ---
RUN docker-php-ext-install \
    pdo pdo_mysql pdo_pgsql mbstring zip gd intl bcmath opcache

# --- CREATE NON-ROOT USER ---
RUN groupadd -f -g ${HOST_UID} vscode \
    && useradd -m -s /bin/bash -u ${HOST_UID} -g vscode vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# --- COMPOSER INSTALL ---
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# --- WORKDIR SETUP ---
WORKDIR /app
RUN chown -R vscode:vscode /app

# --- OPTIONAL: Oh My Bash ---
USER vscode
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
USER root

CMD ["sleep", "infinity"]
