# wordpress

Make production-ready images.

### Features
- Simple wp app with custom themes and plugins.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
######## create database and user
mysql -uroot -proot
DROP DATABASE IF EXISTS wp;
DROP USER IF EXISTS wp;
CREATE DATABASE IF NOT EXISTS wp;
CREATE USER IF NOT EXISTS 'wp'@'%' IDENTIFIED BY 'wp';
GRANT ALL ON wp.* TO 'wp'@'%';

######## production
docker build -f Dockerfile.prod -t wp-app:release $PWD
# run container
docker run --name wp-app -itd -p 8080:80 wp-app:<TAG>
# check logs
docker logs -f wp-app

######## development
docker-compose up -d
docker-compose down
docker-compose logs -f wp-app
```

Open http://localhost:8080 in your browser.
