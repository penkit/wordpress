FROM php:5.6-apache

# Gets WordPress version
ARG wp_version
ENV WP_VERSION $wp_version

WORKDIR /var/www/

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      libjpeg-dev \
      libpng12-dev \
      wget; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache; \
    wget https://wordpress.org/wordpress-$WP_VERSION.tar.gz; \
    tar -xzvf wordpress-$WP_VERSION.tar.gz; \
    rmdir html; \
    mv wordpress html; \
    service apache2 restart;

# Send in wp-config.php that uses ENV
COPY wp-config.php .