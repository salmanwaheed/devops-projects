# mydbr-with-php

Make production-ready images.

### Features
- Simple mydbr app with one API endpoint.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
######## create database and user
mysql -uroot -proot
DROP DATABASE IF EXISTS mydbr;
DROP USER IF EXISTS mydbr;
CREATE DATABASE IF NOT EXISTS mydbr;
CREATE USER IF NOT EXISTS 'mydbr'@'%' IDENTIFIED BY 'mydbr';
GRANT ALL ON mydbr.* TO 'mydbr'@'%';

######## production
docker build -f Dockerfile.prod -t mydbr-app:release $PWD
# run container
docker run --name mydbr-app -itd -p 8080:80 mydbr-app:<TAG>
# check logs
docker logs -f mydbr-app

######## development
docker-compose up -d
docker-compose down
docker-compose logs -f mydbr-app
```

Open http://localhost:8080 in your browser, username & password `dba`.
