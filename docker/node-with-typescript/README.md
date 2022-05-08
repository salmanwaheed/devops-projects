# node-with-typescript

Make production-ready images.

### Features
- Simple Node app with one API endpoint.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
######## production
docker build -f Dockerfile.prod -t node-app:release $PWD
docker run --name node-app -itd -p 3000:3000 node-app:release
docker logs -f node-app

######## development
docker-compose up -d
docker-compose down -v
docker-compose logs -f node-app
```

Open http://localhost:3000 in your browser.
