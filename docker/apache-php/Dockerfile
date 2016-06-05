
# Requirements from https://www.drupal.org/requirements/php#drupalversions

# See: https://github.com/docker-library/php/tree/master/5.5/apache
FROM php:5.5-apache

VOLUME /var/www

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev mysql-client-5.5 git \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mbstring opcache pdo pdo_mysql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# copy Apache overrides
COPY ./docker/apache-php/apache2.conf /etc/apache2/apache2.conf

# install Drush and Composer
COPY ./scripts /usr/local/lib/scripts
RUN /usr/local/lib/scripts/composer-init.sh -b /usr/local/bin

ENV PATH "/var/www/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
WORKDIR /var/www/web

# ensure code base is built and start web server
COPY ./docker/apache-php/bootstrap.sh /usr/local/bin/bootstrap
ENTRYPOINT ["bootstrap"]
CMD []
