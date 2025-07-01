#!/bin/bash
set -e

echo "[+] Uninstalling..."
sudo rm -rf /usr/local/bin/rome-cli /etc/rome-cli
# pip uninstall -y -r requirements.txt
