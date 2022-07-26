# spring-boot-with-java

Make production-ready images.

### Features
- Simple spring-boot app with one endpoint.
- Docker image with small size using multi-stage build.
- Easy to run locally and in production.

### How to run

```sh
# https://start.spring.io/

######## production
docker build -f Dockerfile.prod -t spring-boot-app:release $PWD
docker run --name spring-boot-app -itd -p 8080:8080 spring-boot-app:release
docker logs -f spring-boot-app
```

Open http://localhost:8080 in your browser.
