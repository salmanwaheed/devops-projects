#!/bin/bash

# --- Define constants ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CERT_DIR=$HOME/.mkcert

# --- Detect OS ---
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_ID="${ID,,}" # lowercase
  OS_FAMILY="${ID_LIKE,,}"
else
  echo "[ERROR] Cannot detect OS type (missing /etc/os-release)"
  exit 1
fi
echo "[INFO] Detected OS: $PRETTY_NAME"

# --- Install dependencies ---
echo "[INFO] Installing required packages..."
if [[ "$OS_ID" =~ ^(debian|ubuntu)$ || "$OS_FAMILY" == *"debian"* ]]; then
  sudo apt update -qq >/dev/null 2>&1
  sudo apt install -y nginx openssl libnss3-tools >/dev/null 2>&1
elif [[ "$OS_ID" =~ ^(rhel|almalinux|centos|fedora)$ || "$OS_FAMILY" == *"rhel"* ]]; then
  sudo dnf install -y nginx openssl nss-tools >/dev/null 2>&1
else
  echo "[ERROR] Unsupported OS: $OS_ID"
  exit 1
fi

# --- Download and Install mkcert package ---
echo "[INFO] Installing mkcert binary into /usr/local/bin"
if ! command -v mkcert >/dev/null 2>&1; then
  sudo wget -qO /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64
  sudo chmod +x /usr/local/bin/mkcert
  echo "[INFO] Installed mkcert version: $(mkcert --version)"
else
  echo "[INFO] mkcert already installed (version: $(mkcert --version))"
fi

echo "[INFO] Creating certificate directory: $CERT_DIR/certs"
mkdir -p $CERT_DIR/certs

echo "[INFO] Installing local CA into system/browser trust stores"
mkcert -install

echo "[INFO] Generating TLS key and certificate for localhost + yc.local"
mkcert \
  -key-file $CERT_DIR/certs/localhost.key.pem \
  -cert-file $CERT_DIR/certs/localhost.crt.pem \
  localhost 127.0.0.1 "::1" yc.local "*.yc.local"

echo "[INFO] Copying certificates to /etc/nginx/certs/"
sudo mkdir -p /etc/nginx/certs
sudo cp $CERT_DIR/certs/localhost.* /etc/nginx/certs/

echo "[INFO] Setting up NGINX site configuration"
sudo mkdir -p /etc/nginx/sites-{available,enabled}
sudo cp $SCRIPT_DIR/nginx.conf /etc/nginx
sudo cp $SCRIPT_DIR/default /etc/nginx/sites-available/default
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo "[INFO] Cleaning up old NGINX config directories"
sudo rm -rf /etc/nginx/{conf,default}.d

echo "[INFO] Testing and restarting NGINX service"
sudo nginx -t && sudo systemctl restart nginx
