FROM php:5.6-fpm
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
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    msmtp \
    mysql-client \
    nodejs

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath \
    gd \
    intl \
    mbstring \
    mcrypt \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    xsl \
    zip

RUN pecl install -o -f xdebug-2.5.0

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini;

ENV COMPOSER_CACHE_DIR /home/www-data/.composer
ENV HTML_DIR /var/www/htdocs
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

RUN curl -O https://files.magerun.net/n98-magerun.phar \
    && mv n98-magerun.phar /usr/local/bin/n98 \
    && chmod +x /usr/local/bin/n98

COPY common/template/ $TEMPLATE_DIR/

COPY 5.6/bin/docker-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure

WORKDIR $HTML_DIR

ENTRYPOINT ["/usr/local/bin/docker-configure"]
CMD ["php-fpm"]
