#!/bin/sh
set -e

# chmod -R www-data:www-data /var/www/html
export HTTP_HOST=localhost

# Runtime variables
: "${DB_NAME:=wp}"
: "${DB_USER:=wp}"
: "${DB_PASS:=wp}"
: "${DB_HOST:=localhost}"
: "${DB_PORT:=3306}"
: "${THEME_NAME:=sample-theme}"

if [ ! -f /var/www/html/wp-config.php ]; then
  wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}:${DB_PORT}" \
    --skip-check \
    --allow-root
fi

if ! wp core is-installed --allow-root; then
  wp core install \
    --url="http://localhost:8080" \
    --title="Docker WP" \
    --admin_user="admin" \
    --admin_password="admin" \
    --admin_email="admin@example.com" \
    --allow-root
fi

wp theme activate "${THEME_NAME}" --allow-root

php-fpm -D
nginx -g "daemon off;"

exec "$@"
