# react-with-typescript

Make production-ready images.

### Features
- Simple react app with one endpoint.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
# npx create-react-app my-app --template typescript

######## production
docker build -f Dockerfile.prod -t react-app:release $PWD
docker run --name react-app -itd -p 3001:80 react-app:release
docker logs -f react-app

######## development
docker-compose up -d
docker-compose down -v
docker-compose logs -f react-app
```

Open http://localhost:3001 in your browser.
