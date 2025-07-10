#!/bin/sh
set -e

# chmod -R www-data:www-data /var/www/html

php-fpm -D
nginx -g "daemon off;"

exec "$@"
