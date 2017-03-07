FROM php:5.6-apache

# Gets WordPress version
ARG wp_version
ENV WP_VERSION $wp_version

WORKDIR /var/www/

# wp-config.php that uses ENV
COPY wp-config.php .

# WP DB file
COPY db_dump/penkit-wp-$WP_VERSION.sql db_dump/

# Entrypoint scripts
COPY wait-for-it.sh .
COPY wp-entrypoint.sh .

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      libjpeg-dev \
      libpng12-dev \
      mysql-client \
      wget; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache; \
    wget https://wordpress.org/wordpress-$WP_VERSION.tar.gz; \
    tar -xzvf wordpress-$WP_VERSION.tar.gz; \
    rmdir html; \
    mv wordpress html; \
    mv wp-config.php html/; \
    chmod a+x \
      wp-entrypoint.sh \ 
      wait-for-it.sh; \
    service apache2 restart;

ENTRYPOINT ["./wp-entrypoint.sh"]
