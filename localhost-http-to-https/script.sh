#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cert_dir_path=$HOME/.mkcert

sudo dnf install -y nginx nss-tools openssl

# install mkcert if not installed
if ! command -v mkcert >/dev/null 2>&1; then
  sudo wget -O /usr/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64
  sudo chmod +x /usr/bin/mkcert
else
  echo "mkcert is already the newest version ($(mkcert --version))"
fi

mkdir -p $cert_dir_path/certs

mkcert -install
mkcert \
  -key-file $cert_dir_path/certs/localhost.key.pem \
  -cert-file $cert_dir_path/certs/localhost.crt.pem \
  localhost \
  127.0.0.1 \
  "::1" \
  yc.local \
  "*.yc.local"

# copy certs to nginx dir
sudo mkdir -p /etc/nginx/certs
sudo cp $cert_dir_path/certs/localhost.* /etc/nginx/certs/

sudo mkdir -p /etc/nginx/sites-{available,enabled}

sudo cp $script_dir/nginx.conf /etc/nginx
sudo cp $script_dir/default /etc/nginx/sites-available/default
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

sudo rm -rf /etc/nginx/{conf,default}.d

# reload nginx
sudo nginx -t && sudo systemctl restart nginx
