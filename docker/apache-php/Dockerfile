
# Requirements from https://www.drupal.org/requirements/php#drupalversions

# See: https://github.com/docker-library/php/tree/master/5.5/apache
FROM php:5.5-apache

VOLUME /var/www

# tweak Apache
RUN a2enmod rewrite
RUN a2dissite 000-default
COPY ./docker/apache-php/apache2.conf /etc/apache2/apache2.conf

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev postgresql-client node-less git \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mbstring opcache pdo pdo_pgsql zip

# set recommended PHP.ini settings
ENV PHP_CONF_DIR /usr/local/etc/php/conf.d

# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > ${PHP_CONF_DIR}/opcache-recommended.ini

# install Twig extension.
ENV TWIG_VERSION 1.22.3
ENV TWIG_MD5 41245d409760a0a1d27108a5470e2f6f
RUN mkdir /tmp/twig && cd /tmp/twig \
  && curl -fSL "https://github.com/twigphp/Twig/archive/v${TWIG_VERSION}.tar.gz" -o twig.tar.gz \
  && echo "${TWIG_MD5} *twig.tar.gz" | md5sum -c - \
  && tar -xz --strip-components=1 -f twig.tar.gz \
  && rm twig.tar.gz \
  && cd ext/twig && phpize \
  && ./configure && make && make install \
  && cp /tmp/twig/ext/twig/modules/twig.so $(php-config --extension-dir) \
  && echo "extension=twig.so" > ${PHP_CONF_DIR}/twig.ini \
  && cd /tmp && rm -vrf /tmp/twig

# install Composer
COPY ./scripts /usr/local/lib/scripts
RUN /usr/local/lib/scripts/composer-init.sh -b /usr/local/bin

# environment setup
ENV PATH "/var/www/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
WORKDIR /var/www/web

# ensure code base is built and start web server
COPY ./docker/apache-php/bootstrap.sh /usr/local/bin/bootstrap
ENTRYPOINT ["bootstrap"]
CMD []
