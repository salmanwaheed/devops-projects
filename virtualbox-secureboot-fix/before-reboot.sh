#!/bin/bash
set -e

# (Optional) Find MOK files or check enrolled keys
# sudo find / -type f \( -name "MOK.der" -o -name "MOK.priv" \)
# mokutil --list-enrolled | grep -A 1 'VirtualBox'

MOK_PATH=/var/lib/shim-signed/mok

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

echo "[INFO] Installing required packages..."
if [[ "$OS_ID" =~ ^(debian|ubuntu)$ || "$OS_FAMILY" == *"debian"* ]]; then
  sudo apt update -qq >/dev/null 2>&1
  sudo apt install -y zstd virtualbox virtualbox-dkms virtualbox-guest-additions-iso linux-headers-generic mokutil >/dev/null 2>&1
elif [[ "$OS_ID" =~ ^(rhel|almalinux|centos|fedora)$ || "$OS_FAMILY" == *"rhel"* ]]; then
  sudo dnf install -y zstd VirtualBox-7.2 kernel-devel kernel-headers mokutil >/dev/null 2>&1
else
  echo "[ERROR] Unsupported OS: $OS_ID"
  exit 1
fi

echo "[INFO] Creating $MOK_PATH"
sudo mkdir -p $MOK_PATH

if [ ! -f $MOK_PATH/MOK.der ]; then
  echo "[INFO] Generating MOK key pair..."
  sudo openssl req -nodes -new -x509 -newkey rsa:2048 -outform DER -addext "extendedKeyUsage=codeSigning" -keyout $MOK_PATH/MOK.priv -out $MOK_PATH/MOK.der -subj "/CN=VirtualBox/" >/dev/null 2>&1
else
  echo "[INFO] MOK key already exists, skipping generation."
fi

echo
echo "==== This is NOT your system password - it will be used after reboot in the blue MOK screen."
echo
echo "[INFO] Importing MOK key (You'll be prompted for a one-time password)..."
sudo mokutil --import $MOK_PATH/MOK.der

echo "[INFO] MOK import complete. Please REBOOT and enroll the key in the blue MOK screen."
# sudo reboot
