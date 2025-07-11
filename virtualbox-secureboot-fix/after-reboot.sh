#!/bin/bash
set -e

KERNEL_VER=$(uname -r)
MODULE_PATH=/usr/lib/modules/${KERNEL_VER}/updates/dkms
MOK_PATH=/var/lib/shim-signed/mok

echo "[+] Decompressing VirtualBox DKMS modules..."
sudo zstd -fq -d $MODULE_PATH/vboxdrv.ko.zst
sudo zstd -fq -d $MODULE_PATH/vboxnetadp.ko.zst
sudo zstd -fq -d $MODULE_PATH/vboxnetflt.ko.zst

echo "[+] Signing kernel modules with MOK..."
for module_name in vboxdrv vboxnetadp vboxnetflt; do
  sudo /usr/src/linux-headers-${KERNEL_VER}/scripts/sign-file sha256 \
    $MOK_PATH/MOK.priv \
    $MOK_PATH/MOK.der \
    $MODULE_PATH/$module_name.ko
done

# echo "[+] Loading modules..."
# sudo modprobe vboxdrv vboxnetflt vboxnetadp

echo "[+] Regenerating module dependency list..."
sudo depmod -a

echo "[+] Verifying signatures..."
modinfo $MODULE_PATH/vboxdrv.ko | grep signer
modinfo $MODULE_PATH/vboxnetflt.ko | grep signer
modinfo $MODULE_PATH/vboxnetadp.ko | grep signer

echo "[+] Restarting virtualbox..."
sudo systemctl restart virtualbox.service

echo "[+] Done! Modules signed and loaded."
