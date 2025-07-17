from flask import Flask, request, redirect, render_template, url_for
import sqlite3
import hashlib
from pathlib import Path

app = Flask(__name__)

BASE_PATH = Path(__file__).resolve().parent
DB_PATH = Path(f"{BASE_PATH}/data/snapurl.db")
DB_PATH.parent.mkdir(parents=True, exist_ok=True)

def init_db():
  if not DB_PATH.exists():
    print(f"Creating new DB at {DB_PATH}")

  with sqlite3.connect(str(DB_PATH)) as conn:
    conn.execute("""
    CREATE TABLE IF NOT EXISTS urls (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      original_url TEXT NOT NULL,
      short_code TEXT UNIQUE NOT NULL
    )
    """)
    conn.commit()

init_db()

def generate_short_code(url):
  return hashlib.md5(url.encode()).hexdigest()[:6]

def store_url(original_url):
  short_code = generate_short_code(original_url)
  with sqlite3.connect(str(DB_PATH)) as conn:
    existing = conn.execute("SELECT 1 FROM urls WHERE short_code = ?", (short_code,)).fetchone()
    if not existing:
      conn.execute("INSERT INTO urls (original_url, short_code) VALUES (?, ?)", (original_url, short_code))
      conn.commit()
  return short_code

def get_all_urls():
  with sqlite3.connect(str(DB_PATH)) as conn:
    return conn.execute("SELECT original_url, short_code FROM urls").fetchall()

def get_url_by_code(short_code):
  with sqlite3.connect(str(DB_PATH)) as conn:
    result = conn.execute("SELECT original_url FROM urls WHERE short_code = ?", (short_code,)).fetchone()
    return result[0] if result else None

def update_url(short_code, new_url):
  with sqlite3.connect(str(DB_PATH)) as conn:
    conn.execute("UPDATE urls SET original_url = ? WHERE short_code = ?", (new_url, short_code))
    conn.commit()

def delete_url(short_code):
  with sqlite3.connect(str(DB_PATH)) as conn:
    conn.execute("DELETE FROM urls WHERE short_code = ?", (short_code,))
    conn.commit()

@app.route('/', methods=['GET', 'POST'])
def index():
  if request.method == 'POST':
    original_url = request.form['url']
    store_url(original_url)
    return redirect(url_for('index'))
  urls = get_all_urls()
  return render_template('index.html', urls=urls)

@app.route('/<short_code>')
def redirect_to_url(short_code):
  original_url = get_url_by_code(short_code)
  if original_url:
    return redirect(original_url)
  return render_template("not_found.html"), 404

@app.route('/edit/<short_code>', methods=['GET', 'POST'])
def edit(short_code):
  if request.method == 'POST':
    new_url = request.form['url']
    update_url(short_code, new_url)
    return redirect(url_for('index'))
  original_url = get_url_by_code(short_code)
  return render_template('edit.html', short_code=short_code, original_url=original_url)

@app.route('/delete/<short_code>')
def delete(short_code):
  delete_url(short_code)
  return redirect(url_for('index'))

if __name__ == '__main__':
  app.run(host="0.0.0.0", port=5000)
