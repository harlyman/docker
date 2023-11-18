FROM php:8.1-apache

RUN apt-get update -y && apt-get install -y sendmail  \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  zlib1g-dev \
  libxml2-dev \
  libzip-dev \
  libonig-dev \
  graphviz \
  && docker-php-ext-configure gd \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install mysqli \
  && docker-php-ext-install zip \
  && docker-php-source delete

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite
RUN service apache2 restart
RUN apachectl -t -D DUMP_MODULES | grep rewrite