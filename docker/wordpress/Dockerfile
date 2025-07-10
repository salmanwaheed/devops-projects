FROM wordpress:6.8.1-php8.2-fpm-alpine

RUN apk add --no-cache nginx

WORKDIR /var/www/html

RUN cp -a /usr/src/wordpress/. /var/www/html/ \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /usr/src

COPY nginx/default /etc/nginx/http.d/default.conf
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY --chown=www-data:www-data sample-plugin/ wp-content/plugins/sample-plugin/
COPY --chown=www-data:www-data sample-theme/ wp-content/themes/sample-theme/

COPY start.sh /
CMD ["/start.sh"]
