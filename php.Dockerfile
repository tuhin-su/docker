# Start with the official Debian base
FROM debian:bookworm

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic tools
RUN apt-get update && apt-get install -y \
    curl wget vim net-tools iproute2 apt-transport-https lsb-release ca-certificates gnupg2 sudo git unzip zip curl sudo \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev \
    libzip-dev libicu-dev \
    libpq-dev \
    mariadb-client \
    redis-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



RUN curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-php.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list

# Install PHP 8.2 and PHP 8.4
RUN apt-get update && apt-get install -y \
    php8.2-mbstring php8.2-cli php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-intl php8.2-bcmath php8.2-mysql php8.2-pgsql php8.2-sqlite3 \
    php8.4-mbstring php8.4-cli php8.4-xml php8.4-curl php8.4-zip php8.4-gd php8.4-intl php8.4-bcmath php8.4-mysql php8.4-pgsql php8.4-sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# # Set default PHP to 8.4 (can be switched later)
RUN update-alternatives --install /usr/bin/php php /usr/bin/php8.2 82 \
    && update-alternatives --install /usr/bin/php php /usr/bin/php8.4 84 \
    && update-alternatives --set php /usr/bin/php8.4


# Add phpswitch helper
RUN echo '#!/bin/bash\n\
if [ "$1" = "8.2" ]; then\n\
    sudo update-alternatives --set php /usr/bin/php8.2\n\
elif [ "$1" = "8.4" ]; then\n\
    sudo update-alternatives --set php /usr/bin/php8.4\n\
else\n\
    echo "Usage: phpswitch {8.2|8.4}"\n\
fi' > /usr/local/bin/phpswitch \
    && chmod +x /usr/local/bin/phpswitch

# Add direct version shortcuts
RUN ln -s /usr/bin/php8.2 /usr/local/bin/php82 \
    && ln -s /usr/bin/php8.4 /usr/local/bin/php84

RUN apt update && apt install -y zsh && apt clean && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g yarn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create vscode user with UID 1000 and give sudo rights (NOPASSWD)
RUN useradd -m -s /bin/zsh -u 1000 vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /www && chown -R vscode:vscode /www

# Install Oh My Zsh for vscode
USER vscode
WORKDIR /home/vscode
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/vscode/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/vscode/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /home/vscode/.zshrc

# Default shell = zsh
CMD ["zsh"]
