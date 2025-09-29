#!/bin/bash

set -euo pipefail

# Fedora 42 KVM image:
# https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2

export LIBVIRT_DEFAULT_URI="qemu:///system"

VM_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

VM_NAME="fedora"
VM_USER="fedora"
VM_POOL="/var/lib/libvirt/images"
VM_DISK="${VM_POOL}/${VM_NAME}.qcow2"
VM_SEED_ISO="${VM_POOL}/${VM_NAME}-seed.iso"
VM_QCOW_SRC=$(ls -1t ~/Downloads/bootable-images/kvm/Fedora*42*.qcow2 | head -1)
VM_PUB_KEY=$(cat ~/.ssh/dev.pub)
VM_SEED_DATA="${VM_SCRIPT_PATH}/cloud-init.${VM_NAME}"
VM_OS_VARIANT="fedora41" # virt-install --osinfo list | grep -E "fedora|amazon"

# Install deps
# sudo dnf install -y @virtualization cloud-utils
# sudo systemctl enable --now libvirtd

# Add current user to libvirt/kvm
# sudo usermod -aG kvm,libvirt $USER

# Start default network
# virsh net-autostart default
# virsh net-start default

# Cleanup old VM
virsh destroy "$VM_NAME" --remove-logs --graceful 2>/dev/null || true
virsh undefine "$VM_NAME" --remove-all-storage 2>/dev/null || true

# Prepare disk
sudo mkdir -p "$VM_POOL"
sudo cp "$VM_QCOW_SRC" "$VM_DISK"
sudo chown qemu:qemu "$VM_DISK"

# Prepare cloud-init
mkdir -p "$VM_SEED_DATA"

cat > "$VM_SEED_DATA/user-data" <<EOF
#cloud-config
timezone: Asia/Dubai

bootcmd:
  - systemctl stop sshd.service
  - [sh, -c, 'echo "\nPS1=\"[\u@\h \W] # \"" | sudo tee -a /etc/skel/.profile']

runcmd:
  - hostnamectl hostname ip-\$(hostname -I | awk '{print \$1}' | tr '.' '-')
  - systemctl restart sshd.service

users:
  - name: $VM_USER
    sudo: ['ALL=(ALL) NOPASSWD: ALL']
    shell: /bin/bash
    ssh_authorized_keys:
      - $VM_PUB_KEY
EOF

cat > "$VM_SEED_DATA/meta-data" <<EOF
instance-id: i-${VM_NAME}
local-hostname: ${VM_NAME}
EOF

sudo cloud-localds "$VM_SEED_ISO" "$VM_SEED_DATA/user-data" "$VM_SEED_DATA/meta-data"

# Create VM
virt-install \
  --name "$VM_NAME" \
  --memory 2048 \
  --vcpus 2 \
  --disk path=$VM_DISK,format=qcow2,size=10 \
  --disk path=$VM_SEED_ISO,format=raw \
  --os-variant "$VM_OS_VARIANT" \
  --virt-type kvm \
  --graphics none \
  --import \
  --noautoconsole

# Usage:
# virsh destroy $VM_NAME
# virsh undefine $VM_NAME --remove-all-storage
# virsh start $VM_NAME
# virsh console $VM_NAME
# virsh dominfo $VM_NAME
# virsh domifaddr $VM_NAME
# virsh net-dhcp-leases default
#
# ssh -i ~/.ssh/dev.pem $VM_USER@<IP_ADDRESS>
