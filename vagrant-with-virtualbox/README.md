# AlmaLinux 9 Vagrant VM Setup Guide

This guide describes how to spin up an **AlmaLinux 9** virtual machine using Vagrant and VirtualBox, with SSH key injection, network setup, and useful provisioning.

---

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- SSH public key at `~/.ssh/almalinux.pub` (or your preferred key)

---

## 🚀 How to Use

1. **Initialize the VM**
   ```bash
   vagrant up
   ```

2. **SSH into the VM**
   ```bash
   vagrant ssh
   ```

3. **Or connect via SSH manually**
   ```bash
   ssh vagrant@192.168.56.18 -p 2900
   ```

> Default password authentication is disabled; use your SSH key.

---

## 🔧 Customization Notes

| Feature                 | Default Value                 | You Can Change...               |
|------------------------|-------------------------------|----------------------------------|
| Host IP                | `192.168.56.18`               | To any available in `192.168.56.0/24` |
| Host Port (SSH)        | `2900`                        | To avoid conflicts              |
| VM Resources           | `2 CPUs`, `2 GB RAM`          | Via `vb.cpus`, `vb.memory`      |
| SSH Key                | `~/.ssh/almalinux.pub`           | Use any local `.pub` file       |
