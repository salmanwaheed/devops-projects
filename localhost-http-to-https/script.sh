#!/bin/bash

dir_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cert_dir_path=$HOME/.mkcert

sudo apt-get install -y nginx libnss3-tools openssl

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
  yc.local \
  "*.yc.local"

# copy certs to nginx dir
sudo mkdir -p /etc/nginx/certs
sudo cp $cert_dir_path/certs/localhost.* /etc/nginx/certs/

sudo cp default /etc/nginx/sites-available/default
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# reload nginx
sudo nginx -t && sudo systemctl restart nginx
