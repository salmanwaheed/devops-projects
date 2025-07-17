# SnapURL - A Simple URL Shortener with CRUD Support

SnapURL is a basic URL shortener built using Python, Flask, and SQLite. It supports creating, reading, updating, and deleting shortened URLs.

---

## Features

- Shorten long URLs.
- List all shortened URLs.
- Edit existing short URL destinations.
- Delete short URLs.
- Redirect short URLs to their original destinations.
- Ready for production using **Gunicorn** + **SQLite**.

---

## Project Structure

```
snapurl/
├── app.py                 # Main Flask application
├── data/snapurl.db        # SQLite database (created on first run)
├── requirements.txt       # Python dependencies
├── gunicorn.conf.py       # Gunicorn configuration (for production)
└── templates/
    ├── index.html         # Home + dashboard page
    └── edit.html          # Edit page for updating URLs
    └── not_found.html     # 404 page not found
```

---

## Installation

```sh
# Clone the repository
git clone git@github.com:salmanwaheed/devops-projects.git
cd devops-projects/docker/snapurl

# (Optional) Create a virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the app for development
python -m app

# for production
gunicorn -c gunicorn.conf.py app:app

######## OR, use docker ########
######## production
docker build -f Dockerfile.prod -t snapurl-app:release $PWD
docker run --name snapurl-app -itd -p 5000:5000 -v snapurl-data:/app/data snapurl-app:release
docker logs -f snapurl-app

######## development
docker-compose up -d
docker-compose down
docker-compose logs -f snapurl-app
```

Open http://localhost:5000 in your browser.

---

## Usage

- Enter a long URL in the form and click "Shorten".
- View the list of all your short URLs below the form.
- Click "Edit" to change the original destination URL.
- Click "Delete" to remove a short URL.
- Accessing `/shortcode` redirects to the original URL.

---

## Routes

```txt
GET     /                     - Homepage, form + list of URLs
POST    /                     - Submit URL to shorten
GET     /<short_code>         - Redirect to original URL
GET     /edit/<short_code>    - Form to edit a URL
POST    /edit/<short_code>    - Submit updated URL
GET     /delete/<short_code>  - Delete a short URL
```

## sqlite3

```sh
docker exec -it snapurl-app sh
apk add --no-cache sqlite

sqlite3 data/snapurl.db
sqlite> .tables
sqlite> SELECT * FROM urls;
```
