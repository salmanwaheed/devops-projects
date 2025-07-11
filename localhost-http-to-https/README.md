# Local HTTPS Setup with mkcert and Nginx

This project provides a simple way to enable HTTPS on `localhost` using [mkcert](https://github.com/FiloSottile/mkcert) and Nginx.

## Requirements

- Ubuntu or Debian-based Linux system: `wget`, `openssl`, `nginx`, `libnss3-tools`, `PHP-FPM (if using PHP)`.

## Setup Instructions

### 1. Clone or download this repo

```bash
git clone https://github.com/salmanwaheed/devops-projects.git
cd localhost-http-to-https
```

---

### 2. Run the setup script

This will:
- Install `nginx`, `mkcert`, and dependencies
- Generate trusted SSL certificates for:
  - `localhost`
  - `127.0.0.1`
  - `yc.local`
  - `*.yc.local`
- Copy the certs to `/etc/nginx/certs/`
- Replace / Update server config `/etc/nginx/sites-enabled/default`
- Restart Nginx.

```bash
chmod +x script.sh
./script.sh
```

---

### 4. Test HTTPS in Browser

To use custom domains like `*.yc.local`, you must map them in `/etc/hosts`.

```bash
echo "127.0.0.1 yc.local sub.yc.local" | sudo tee -a /etc/hosts

# add `<CUSTOM_DOMAIN>` to ./script.sh first
echo "<IP_ADDRESS> <CUSTOM_DOMAIN>" | sudo tee -a /etc/hosts
```

Then visit example localhost URLs:
- https://localhost
- https://yc.local
- https://sub.yc.local
- https://<CUSTOM_DOMAIN>

Make sure the padlock icon appears in your browser, indicating a valid certificate.

---

## Configuration Notes

### SSL Certificates

- Certificates are generated with `mkcert` and stored in `~/.mkcert/certs/`.
- They're copied to `/etc/nginx/certs/` for Nginx to access.

### Nginx Highlights

- HTTP (port 80) redirects to HTTPS.
- HTTPS (port 443) serves your-apps or PHP-apps via FastCGI.
- `TLSv1.2` and `TLSv1.3` are enabled.
- Strong cipher suites used for development security.

---

## Uninstall / Cleanup

To remove certs and reset:

```bash
mkcert -uninstall
sudo rm -rf ~/.mkcert /etc/nginx/certs
sudo apt remove --purge nginx
```
