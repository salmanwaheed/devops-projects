#!/bin/bash
set -e

# (Optional) Find MOK files or check enrolled keys
# sudo find / -type f \( -name "MOK.der" -o -name "MOK.priv" \)
# mokutil --list-enrolled | grep -A 1 'VirtualBox'

echo "[+] Installing required packages..."
sudo apt install -y zstd virtualbox virtualbox-dkms virtualbox-guest-additions-iso linux-headers-generic mokutil >/dev/null 2>&1

echo "[+] Generating MOK key pair..."
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -out MOK.pem -nodes -days 36500 -subj "/CN=VirtualBox/" 2>/dev/null

openssl x509 -outform DER -in MOK.pem -out MOK.der

echo "[+] Copying MOK keys to system path..."
sudo mkdir -p /var/lib/shim-signed/mok
sudo cp MOK.{der,priv} /var/lib/shim-signed/mok/

echo
echo "==== This is NOT your system password - it will be used after reboot in the blue MOK screen."
echo
echo "[+] Importing MOK key (You'll be prompted for a one-time password)..."
sudo mokutil --import /var/lib/shim-signed/mok/MOK.der

echo "MOK import complete. Please REBOOT and enroll the key in the blue MOK screen."
# sudo reboot
