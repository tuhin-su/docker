ARG PHP_VER

FROM php:${PHP_VER:-8.4}-fpm-alpine

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV APP_ROOT="/app"
ENV PATH="$PATH:/home/vscode/.composer/vendor/bin:$APP_ROOT/vendor/bin:$APP_ROOT/bin"
ENV PHP_EXTENSIONS_DISABLE='xdebug,xhprof,spx'

# Create user and group
RUN set -ex && \
    apk add --no-cache shadow bash sudo git curl wget && \
    groupadd -g "$GROUP_ID" vscode && \
    useradd -u "$USER_ID" -m -s /bin/bash -g vscode vscode && \
    adduser vscode www-data && \
    sed -i '/^vscode/s/!/*/' /etc/shadow

# Install system and PHP build dependencies
RUN set -ex && \
    apk add --no-cache \
        p7zip \
        brotli-libs \
        c-client \
        fcgi \
        findutils \
        freetype \
        gmp \
        gzip \
        icu-libs \
        imagemagick \
        jpegoptim \
        less \
        libavif \
        libbz2 \
        libevent \
        libgd \
        libgomp \
        libjpeg-turbo \
        libjpeg-turbo-utils \
        libldap \
        libmcrypt \
        libpng \
        librdkafka \
        libsmbclient \
        libuuid \
        libwebp \
        libxml2 \
        libxslt \
        libzip \
        make \
        mariadb-client \
        msmtp \
        nano \
        openssh \
        patch \
        pngquant \
        postgresql-client \
        rabbitmq-c \
        rsync \
        sqlite \
        su-exec \
        tar \
        tidyhtml-libs \
        tig \
        tmux \
        unzip \
        yaml

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        binutils \
        cmake \
        brotli-dev \
        build-base \
        bzip2-dev \
        freetype-dev \
        gd-dev \
        gmp-dev \
        icu-dev \
        imap-dev \
        imagemagick-dev \
        jpeg-dev \
        krb5-dev \
        libavif-dev \
        libevent-dev \
        libgcrypt-dev \
        libjpeg-turbo-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libpng-dev \
        librdkafka-dev \
        libtool \
        libwebp-dev \
        libxslt-dev \
        libzip-dev \
        linux-headers \
        openldap-dev \
        openssl-dev \
        pcre-dev \
        postgresql-dev \
        rabbitmq-c-dev \
        samba-dev \
        sqlite-dev \
        tidyhtml-dev \
        unixodbc-dev \
        yaml-dev \
        zlib-dev

# Install PHP extensions
RUN set -ex && \
    docker-php-ext-install \
        bcmath bz2 calendar exif ftp gmp intl ldap mysqli opcache pcntl pdo_mysql \
        pdo_pgsql pgsql soap sockets tidy xsl zip && \
    docker-php-ext-configure gd --with-external-gd --with-webp --with-freetype --with-avif --with-jpeg && \
    docker-php-ext-install gd

# Install common PECL extensions
RUN set -ex && \
    pecl install \
        event \
        apcu \
        ast \
        ds \
        event \
        igbinary \
        imagick \
        memcached \
        mongodb \
        oauth \
        opentelemetry \
        pdo_sqlsrv \
        pcov \
        protobuf \
        rdkafka \
        redis \
        smbclient \
        sqlsrv \
        uploadprogress \
        uuid \
        xdebug \
        xhprof \
        yaml && \
    docker-php-ext-enable \
        event \
        apcu \
        ast \
        ds \
        event \
        igbinary \
        imagick \
        memcached \
        mongodb \
        oauth \
        opentelemetry \
        pdo_sqlsrv \
        pcov \
        protobuf \
        rdkafka \
        redis \
        smbclient \
        sqlsrv \
        uploadprogress \
        uuid \
        xdebug \
        xhprof \
        yaml

# Event extension should be loaded after sockets.
    # http://osmanov-dev-notes.blogspot.com/2013/07/fixing-php-start-up-error-unable-to.html
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-event.ini /usr/local/etc/php/conf.d/z-docker-php-ext-event.ini;
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Oh My Bash for the vscode user
USER vscode
RUN bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)" || true

USER root
RUN chown -R vscode:vscode /home/vscode

USER vscode
WORKDIR /app
EXPOSE 9000

CMD ["sleep", "infinity"]