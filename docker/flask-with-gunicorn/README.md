# flask-with-gunicorn

Make production-ready images.

### Features
- Simple Flask app with one API endpoint.
- Docker image with small size using multi-stage build.
- Runs with Gunicorn in production for better performance.
- Easy to run locally and in production.

### How to run

```sh
######## production
# alpine: 54 MB
docker build -f Dockerfile.alpine -t flask-app:alpine $PWD
# slim: 131 MB
docker build -f Dockerfile.slim -t flask-app:slim $PWD
# run container
docker run --name flask-app -itd -p 5000:5000 flask-app:<TAG>
# check logs
docker logs -f flask-app

######## development
docker-compose up -d
docker-compose down
docker-compose logs -f flask-app
```

Open http://localhost:5000 in your browser.
