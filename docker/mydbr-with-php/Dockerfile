FROM php:8.2-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      unzip \
      zip \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      libonig-dev \
      libzip-dev \
    && docker-php-ext-install zip gd mysqli \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

WORKDIR /usr/local/sourceguardian
RUN curl -LO https://sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz \
    && tar -xvzf loaders.linux-x86_64.tar.gz \
    && cp ixed.8.2.lin /usr/local/lib/php/extensions/no-debug-non-zts-20220829 \
    && echo "extension=ixed.8.2.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini \
    && rm -rf /usr/local/sourceguardian

WORKDIR /var/www/html
RUN curl -L -o mydbr_php82_sg.zip https://mydbr.com/fileserve.php?get=mydbr_php82_sg.zip \
    && unzip -q mydbr_php82_sg.zip -d . \
    && mv ./mydbr/* . \
    && rm -rf mydbr mydbr_php82_sg.zip

ADD info.php mydbr_config.php .
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
RUN chown -R www-data:www-data . && chmod -R u+w .

CMD ["apache2-foreground"]
