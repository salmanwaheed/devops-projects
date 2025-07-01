#!/bin/bash
set -e

APP_NAME=rome-cli
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=$HOME_DIR/dist

echo "[*] Installing dependencies..."
# sudo apt update -qq
sudo apt install -qqy python3-dev build-essential patchelf ccache > /dev/null 2>&1
# sudo apt autoremove -qqy

echo "[+] Creating virtual environment..."
python3 -m venv $HOME_DIR/venv
source $HOME_DIR/venv/bin/activate

echo "[+] Installing required packages..."
pip install --quiet -U nuitka -r $HOME_DIR/requirements.txt # pyarmor==7.6.1 setuptools

echo "[+] Cleaning up previous build..."
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR

# echo "[+] Obfuscating Python code..."
# pyarmor obfuscate $HOME_DIR/app.py

echo "[+] Compiling with Nuitka..."
nuitka --quiet --follow-imports --onefile --output-dir=$BUILD_DIR --output-filename=$APP_NAME $HOME_DIR/app.py

# echo "[+] Stripping symbols from binary..."
# strip $BUILD_DIR/$APP_NAME
# chmod +x $BUILD_DIR/$APP_NAME

echo "[+] Cleaning intermediate folders..."
deactivate
rm -rf $BUILD_DIR/app.{build,dist,onefile-build}

echo "[+] Build complete: $BUILD_DIR/$APP_NAME"

echo "[+] Installing /usr/local/bin/$APP_NAME"
sudo install -m 755 $BUILD_DIR/$APP_NAME /usr/local/bin/$APP_NAME
sudo mkdir -p /etc/$APP_NAME
sudo install -m 644 $HOME_DIR/config.yml /etc/$APP_NAME/config.yml
