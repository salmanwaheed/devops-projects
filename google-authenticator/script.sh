#!/bin/bash
set -euo pipefail

# --- Define constants ---
HOME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GA_FILE="$HOME/.google_authenticator"
PAM_FILE="/etc/pam.d/sshd"
SSH_CONF_DIR="/etc/ssh/sshd_config.d"
AUTH_FILE=totp-auth.conf

echo "[INFO] Starting SSH MFA setup..."

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
  sudo apt install -y libpam-google-authenticator qrencode >/dev/null 2>&1
elif [[ "$OS_ID" =~ ^(rhel|almalinux|centos|fedora)$ || "$OS_FAMILY" == *"rhel"* ]]; then
  sudo dnf install -y epel-release >/dev/null 2>&1
  sudo dnf install -y google-authenticator qrencode >/dev/null 2>&1
else
  echo "[ERROR] Unsupported OS: $OS_ID"
  exit 1
fi

# --- Setup Google Authenticator ---
if [ ! -f "$GA_FILE" ]; then
  echo "[INFO] Configuring Google Authenticator for user: $USER"
  # google-authenticator -t -d -f -r 3 -R 30 -w 3
  google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --window-size=3
else
  echo "[WARN] Google Authenticator already configured for $USER. Skipping..."
fi

# --- SSH config file ---
if [ -f "$HOME_DIR/$AUTH_FILE" ]; then
  echo "[INFO] Copying SSH config to: $SSH_CONF_DIR/10-${AUTH_FILE}"
  sudo cp "$HOME_DIR/$AUTH_FILE" "$SSH_CONF_DIR/10-${AUTH_FILE}"
else
  echo "[ERROR] Missing $AUTH_FILE in $HOME_DIR"
  exit 1
fi

# --- Update PAM configuration ---
if ! grep -q "pam_google_authenticator.so" "$PAM_FILE"; then
  echo "[INFO] Updating PAM config: $PAM_FILE"
  echo "auth required pam_google_authenticator.so" | sudo tee -a "$PAM_FILE" >/dev/null
else
  echo "[INFO] PAM already configured for Google Authenticator. Skipping..."
fi

disable_password_auth() {
  local pattren="$1"
  local replace="$2"

  if grep -q "$pattren" "$PAM_FILE"; then
    echo "[INFO] Commenting out password login line..."
    sudo sed -i "s|$pattren|$replace|" "$PAM_FILE"
  else
    echo "[INFO] Password login already disabled. Skipping..."
  fi
}

configure_selinux() {
  local perm="$1"

  selinux_status=$(getenforce 2>/dev/null || echo "${perm^}")
  if [[ "$selinux_status" == "Enforcing" ]]; then
    echo "[INFO] SELinux is enforcing. Setting to $perm temporarily..."
    sudo setenforce 0

    echo "[INFO] Setting SELinux to $perm permanently..."
    sudo sed -i "s|^SELINUX=enforcing|SELINUX=$perm|" /etc/selinux/config
  else
    echo "[INFO] SELinux is already $perm. Skipping..."
  fi
}

# --- Disable password auth if common-auth is included ---
if [[ "$OS_FAMILY" == *"debian"* ]]; then
  disable_password_auth "^@include common-auth" "#@include common-auth"
elif [[ "$OS_FAMILY" == *"rhel"* ]]; then
  disable_password_auth "^auth\s\+substack\s\+password-auth" "#auth substack password-auth"
  configure_selinux "permissive"
fi

# --- Restart SSH ---
echo "[INFO] Restarting SSH daemon..."
sudo systemctl restart sshd

echo
echo "[SUCCESS] SSH MFA setup complete."
echo "Try logging in using your SSH key and the 6-digit TOTP from your app."
