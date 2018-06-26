FROM php:7.1-fpm

# Node Requirements:
RUN apt-get update \
  && apt-get install -y \
    gnupg1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    gettext \
    msmtp \
    git \
    vim \
    mysql-client \
    nodejs

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    soap \
    bcmath \
    mysqli \
    opcache \
    pcntl

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

RUN pecl install -o -f xdebug-2.5.0

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini;

COPY common/template/custom.ini common/template/xdebug.ini /usr/local/etc/php/conf.d/
COPY common/template/msmtprc /etc/msmtprc.template

# Copy in Entrypoint file
COPY 7.1/bin/docker-configure common/bin/magento-install common/bin/magento-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure /usr/local/bin/magento-install /usr/local/bin/magento-configure

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

WORKDIR /var/www

RUN rm -rf html && mkdir pub && mkdir var && mkdir -p app/etc