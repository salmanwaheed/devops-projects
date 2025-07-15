# Vagrant VM Setup Guide (AlmaLinux / CentOS / Ubuntu)

This repository contains preconfigured **Vagrant environments** for different Linux distributions:

- AlmaLinux 9
- CentOS 7/8
- Ubuntu 22.04

Each environment includes:

- Private network IP.
- Custom SSH port forwarding.
- SSH key injection.
- Basic provisioning tools (e.g., Python, Vim, zip, unzip, ca-certificates, etc.).

---

## Directory Structure

```sh
.
├── almalinux/
│   └── Vagrantfile
├── centos/
│   └── Vagrantfile
├── ubuntu/
│   └── Vagrantfile
└── README.md
```

Each folder is self-contained. You can `cd` into any and run `vagrant up` to launch that VM.

---

## How to Use

### 1. Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

A public SSH key at `~/.ssh/dev.pub` (or customize in the `Vagrantfile`)

```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dev -N ""

chmod 600 ~/.ssh/dev
chmod 644 ~/.ssh/dev.pub
```

---

### 2. Launch a VM

```sh
cd almalinux # or centos, ubuntu
vagrant up
```

---

### 3. Connect to the VMs

#### Option A: Vagrant SSH

```sh
vagrant ssh
```

#### Option B: Manual SSH

| Distro     | IP Address        | SSH Port |
|------------|-------------------|----------|
| AlmaLinux  | `192.168.56.18`   | `5203`   |
| CentOS     | `192.168.56.17`   | `5202`   |
| Ubuntu     | `192.168.56.16`   | `5201`   |

```sh
ssh vagrant@192.168.56.18 -p 5203 -i ~/.ssh/dev # AlmaLinux
ssh vagrant@192.168.56.17 -p 5202 -i ~/.ssh/dev # CentOS
ssh vagrant@192.168.56.16 -p 5201 -i ~/.ssh/dev # Ubuntu
```

> Default password authentication is disabled. Ensure your SSH key is injected properly.

---

## Configuration Notes

| Feature            | Default Value              | Customizable in `Vagrantfile`          |
|--------------------|----------------------------|----------------------------------------|
| IP Address         | See table above            | Use any from `192.168.56.0/24`         |
| SSH Port Forward   | `5201-5203`                | Avoid port conflicts on your machine   |
| CPUs / Memory      | `2 CPUs`, `2048 MB RAM`    | Adjust `vb.cpus` and `vb.memory`       |
| SSH Public Key     | `~/.ssh/dev.pub`           | Change file path in the provisioner    |

---

## Cleanup

To destroy a VM and free resources:

```sh
vagrant destroy -f
```

---

## Notes

- These VMs are intended for **local development and testing**.
- For production or team-based infrastructure, consider using cloud providers with automation tools like Terraform and Ansible.
