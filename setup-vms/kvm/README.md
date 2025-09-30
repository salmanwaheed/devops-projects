# KVM Cloud-Init VM Setup Guide

This guide explains how to quickly create and launch ready-to-SSH KVM virtual machines using `virt-install` and `cloud-init`.

After the one-time setup, you can spin up an `AlmaLinux`, `Amazon Linux`, `CentOS`, `Fedora`, or `Ubuntu` VM with **one script**.

---

## Directory Structure

```txt
kvm/
├── almalinux.sh
├── amazon-linux.sh
├── centos.sh
├── fedora.sh
├── ubuntu.sh
└── README.md
```

---

## How to Use

### 1. Prerequisites

```bash
# Check if virtualization is enabled
egrep -c '(vmx|svm)' /proc/cpuinfo

# install required packages
sudo dnf install -y @virtualization cloud-utils
sudo systemctl enable --now libvirtd

# manage vms without sudo
sudo usermod -aG kvm,libvirt $USER
newgrp libvirt

# Check if KVM modules are loaded
lsmod | grep kvm

# generate an ssh key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dev -N ""

# start the default virtual network
virsh net-autostart default # auto start on every reboot
virsh net-start default # manual start
virsh net-list --all # verify
```

---

### 2. Download Base Cloud Images

Place KVM `.qcow2` / `.img` images in `~/Downloads/bootable-images/kvm/`.

- [Amazon Linux 2023](https://cdn.amazonlinux.com/al2023/os-images/2023.8.20250915.0/kvm/al2023-kvm-2023.8.20250915.0-kernel-6.1-x86_64.xfs.gpt.qcow2)
- [Fedora 42](https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2)
- [Almalinux 9](https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.6-20250522.x86_64.qcow2)
- [CentOS 7](https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2211.qcow2)
- [Ubuntu 24.04](https://cloud-images.ubuntu.com/jammy/20250725/jammy-server-cloudimg-amd64-disk-kvm.img)

---

The script automatically picks the latest matching image for each OS.

### 3. Run a VM Script

Each OS has its own script: `almalinux.sh`, `amazon-linux.sh`, `centos.sh`, `fedora.sh`, and `ubuntu.sh`.

> Example: `./amazon-linux.sh`

What happens:
- Old VM with the same name is destroyed & undefined (safe re-run).
- Disk is copied from the base image.
- Cloud-init `user-data` and `meta-data` are generated.
- A seed ISO is created with SSH key & config.
- A new VM is defined and started with `virt-install`.

---

### 4. Get the VM IP Address

After the VM boots, you can get its IP in multiple ways:

```bash
virsh domifaddr <vm-name>
# OR
virsh net-dhcp-leases default
```

---

### 5. SSH into the VM

Use the username defined in the script (e.g. `ec2-user` for Amazon Linux, fedora, centos or almalinux for others):

```bash
ssh -i ~/.ssh/dev <vm-user>@<vm-ip>
```

---

### 6. Cleanup

To remove a VM completely

```bash
virsh destroy <vm-name> --graceful --remove-logs
virsh undefine <vm-name> --remove-all-storage

# Remove all machines at once
virsh list --name --all | xargs -I{} -n1 virsh destroy "{}" --remove-logs --graceful
virsh list --name --all | xargs -I{} -n1 virsh undefine "{}" --remove-all-storage
```

---

## Useful virsh Commands

```bash
# List all VMs
virsh list --all

# Start / Stop / Delete VM
virsh start <vm-name>
virsh destroy <vm-name>
virsh undefine <vm-name> --remove-all-storage

# Console access
virsh console <vm-name>

# VM details
virsh dominfo <vm-name>
virsh dumpxml <vm-name>

# DHCP leases
virsh net-dhcp-leases default

# Remove default network and re-create
virsh net-destory default
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-start default
virsh net-list --all
virsh net-info default

# Find supported --os-variant=<os-name>
virt-install --osinfo list | grep <os-name>
```

---

## Notes
- Cloud-init automatically sets the hostname to match the IP.
- `runcmd` and `bootcmd` in cloud-init customize prompt & timezone.
- Each script uses different `VM_NAME` and `VM_USER` variables but the logic is identical.
- You can modify memory, CPU, or disk size in the script if needed.
