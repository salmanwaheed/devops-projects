# sinatra-with-ruby

Make production-ready images.

### Features
- Simple sinatra app with one API endpoint.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
######## production
docker build -f Dockerfile.prod -t sinatra-app:release $PWD
docker run --name sinatra-app -itd -p 4567:4567 sinatra-app:release
docker logs -f sinatra-app

######## development
docker-compose up -d
docker-compose down -v
docker-compose logs -f sinatra-app
```

Open http://localhost:4567 in your browser.
