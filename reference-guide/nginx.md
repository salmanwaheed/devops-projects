# NGINX Reference Guide

Nginx is a high-performance web server, reverse proxy, and load balancer.

---

## Quick Tips
- Use `nginx -T` to view all active configs.
- Always test `nginx -t` before reload.
- Logs live in `/var/log/nginx/`.
- Configuration files are usually found in `/etc/nginx/`.
- Split configs in `/etc/nginx/conf.d/*.conf` for clarity.
- Check running ports `sudo netstat -tulpn | grep nginx`.
- Core Structure: `../localhost-http-to-https/nginx.conf`.

---

## Common Directives (Most Used)

| Directive     | Meaning                 | Example                                     |
| ------------- | ----------------------- | ------------------------------------------- |
| `listen`      | Define port/IP          | `listen 80;`                                |
| `server_name` | Domain name             | `server_name example.com;`                  |
| `root`        | Web root                | `root /var/www/html;`                       |
| `index`       | Default file            | `index index.html index.php;`               |
| `error_page`  | Custom error page       | `error_page 404 /404.html;`                 |
| `location`    | Match request path      | `location /api/ { ... }`                    |
| `proxy_pass`  | Reverse proxy target    | `proxy_pass http://127.0.0.1:5000;`         |
| `rewrite`     | Rewrite URL             | `rewrite ^/old$ /new permanent;`            |
| `try_files`   | Try multiple file paths | `try_files $uri $uri/ =404;`                |
| `return`      | Return response         | `return 301 https://$host$request_uri;`     |
| `include`     | Load extra config       | `include /etc/nginx/snippets/fastcgi.conf;` |
| `http`        | Global HTTP settings.   | `http { include mime.types; gzip on; }`     |
| `server`      | Defines a virtual host  | `server { listen 80; server_name example.com; }` |
| `access_log`  | Controls request logging | `access_log /var/log/nginx/access.log main;` |
| `error_log`   | Controls error logging | `error_log /var/log/nginx/error.log warn;` |
| `add_header`  | Adds custom HTTP headers | `add_header X-Proxy $proxy_host;` |
| `proxy_set_header` | Define headers for proxied requests | `proxy_set_header X-Real-IP $remote_addr;` |

---

## Common Variables (Most Used)

| Variable           | Meaning           |
| ------------------ | ----------------- |
| `$host`            | Host header       |
| `$uri`             | Current URI       |
| `$remote_addr`     | Client IP         |
| `$request_uri`     | Full request URI  |
| `$args`            | Query string      |
| `$http_user_agent` | User-Agent        |
| `$scheme`          | `http` or `https` |
| `$server_name`     | Server block name |

---

## Common Modifiers

| Modifier | Meaning                           | Match Type                            | Example                   |      |           |
| -------- | --------------------------------- | ------------------------------------- | ------------------------- | ---- | --------- |
| *(none)* | **Prefix match**                  | Matches the **beginning** of URI      | `location /images/ {}`    |      |           |
| `=`      | **Exact match**                   | Must match the **entire URI exactly** | `location = /about {}`    |      |           |
| `~`      | **Case-sensitive regex match**    | Uses **regular expressions**          | `location ~ \.php$ {}`    |      |           |
| `~*`     | **Case-insensitive regex match**  | Regex ignoring case                   | `location ~* \.(jpg\|jpeg\|png)$ {}` |
| `^~`     | **Prefix match (no regex check)** | Stops searching if matched            | `location ^~ /static/ {}` |      |           |

---

## Basic Server Block

```nginx
server {
  listen 80;
  server_name example.com app2.example.com;
  root /var/www/example;
  index index.html;

  location / {
    try_files $uri $uri/ =404;
  }
}
```

## Static File Hosting

```nginx
server {
  listen 80;
  server_name static.example.com;
  root /var/www/static;
  autoindex on;  # show directory listing
  gzip on;       # enable compression
}
```

## Reverse Proxy (Backend App)

```nginx
server {
  listen 80;
  server_name api.example.com;

  location / {
    proxy_pass http://localhost:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Proxy $proxy_host; # custom header
    # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    # proxy_set_header X-Forwarded-Proto $scheme;
    # proxy_set_header X-Forwarded-Host $host;
    # proxy_set_header X-Forwarded-Port $server_port;
  }
}
```

## Redirect All HTTP requests to HTTPS + Reverse Proxy

Make your localhost secure `../localhost-http-to-https`.

```nginx
server {
  listen 80;
  server_name example.com;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl;
  server_name example.com;

  ssl_certificate /etc/ssl/certs/example.crt;
  ssl_certificate_key /etc/ssl/private/example.key;

  location / {
    proxy_pass http://localhost:8080;
    # ...
  }
}
```

## Load Balancing (Round Robin)

```nginx
upstream backend {
  server 127.0.0.1:8080;
  server 127.0.0.1:8081;
  server 127.0.0.1:8082;
}

server {
  # ...

  location / {
    proxy_pass http://backend;
    # ...
  }
}
```

## PHP with FastCGI (e.g., WordPress)

```nginx
server {
  listen 80;
  server_name blog.example.com;
  root /var/www/blog;
  index index.php index.html;

  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi.conf;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;

    # fastcgi_read_timeout 600s;
    # fastcgi_connect_timeout 60s;
    # fastcgi_send_timeout 600s;
  }
}
```

## References
- https://nginx.org/en/docs
- https://nginx.com/resources/wiki/start
- https://docs.nginx.com/nginx/admin-guide
- https://nginx.org/en/docs/varindex.html
