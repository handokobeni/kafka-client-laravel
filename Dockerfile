FROM php:7.4-fpm
# FROM php:7.4-cli

WORKDIR /var/www/html
# CMD [ "php", "./app.php" ]

ENV LIBRDKAFKA_VERSION 1.4.x
ENV BUILD_DEPS \
        build-essential \
        curl \
        git \
        libsasl2-dev \
        libssl-dev \
        python-minimal \
        zlib1g-dev \
        libzip-dev

RUN apt-get update \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get install -y --no-install-recommends ${BUILD_DEPS} \
    && cd /tmp \
    && git clone \
        --branch ${LIBRDKAFKA_VERSION} \
        --depth 1 \
        https://github.com/edenhill/librdkafka.git \
    && cd librdkafka \
    && ./configure \
    && make \
    && make install \
    && pecl install rdkafka-3.0.3 zip \
    && docker-php-ext-enable rdkafka \
    && docker-php-ext-enable zip \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /tmp/librdkafka \
    && cd /var/www/html \
    && composer require enqueue/rdkafka
    # && apt-get purge \
    #     -y --auto-remove \
    #     -o APT::AutoRemove::RecommendsImportant=false \
    #     ${BUILD_DEPS}
