FROM php:7.2-fpm
MAINTAINER JH <hello@wearejh.com>

RUN apt-get update \
    && apt-get install -y gnupg \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y \
    cron \
    gettext \
    git \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxslt1-dev \
    libsodium-dev \
    msmtp \
    mysql-client \
    nodejs \
    vim

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath \
    gd \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    xsl \
    zip \
    sodium

RUN pecl install -o -f xdebug

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini;

RUN usermod -s $(which bash) www-data

ENV COMPOSER_CACHE_DIR /home/www-data/.composer
ENV MAIL_HOST mail
ENV MAIL_PORT 1025
ENV PHP_FPM_PORT 9000
ENV PHP_MEMORY_LIMIT 512M
ENV POST_MAX_SIZE 20M
ENV TEMPLATE_DIR /etc/docker-configure.template
ENV UPLOAD_MAX_FILESIZE 20M
ENV XDEBUG_AUTOSTART 0
ENV XDEBUG_ENABLE 0
ENV XDEBUG_HOST docker.for.mac.host.internal
ENV XDEBUG_IDE_KEY PHPSTORM
ENV XDEBUG_PORT 9000

ENV XDEBUG_CONFIG=remote_host=$XDEBUG_HOST

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

RUN curl -O https://files.magerun.net/n98-magerun2.phar \
    && mv n98-magerun2.phar /usr/local/bin/n98-magerun2 \
    && chmod +x /usr/local/bin/n98-magerun2

COPY common/template/custom.ini common/template/xdebug.ini /usr/local/etc/php/conf.d/
COPY common/template/msmtprc $TEMPLATE_DIR/

COPY common/bin/docker-configure \
     7.x/bin/magento-install \
     7.x/bin/magento-configure \
     /usr/local/bin/

RUN chmod +x \
    /usr/local/bin/docker-configure \
    /usr/local/bin/magento-install \
    /usr/local/bin/magento-configure

WORKDIR /var/www

RUN rm -rf html && mkdir pub && mkdir var && mkdir -p app/etc

ENTRYPOINT ["/usr/local/bin/docker-configure"]
CMD ["php-fpm"]
