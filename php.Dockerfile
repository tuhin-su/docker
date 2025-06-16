ARG VERSION=latest
FROM  wodby/drupal-php:${VERSION}

ARG HOST_UID=1000

# --- SYSTEM DEPENDENCIES ---
USER root
RUN apk add --no-cache \
    bash sudo curl git unzip zip \
    libpng-dev oniguruma-dev libzip-dev icu-dev libxml2-dev postgresql-dev

RUN deluser --remove-home wodby \
  && addgroup -S vscode -g ${HOST_UID} \
  && adduser -S -G vscode -u ${HOST_UID} -s /bin/bash vscode \
  && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && addgroup vscode wheel
  
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
