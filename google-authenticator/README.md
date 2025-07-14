# SSH Multi-Factor Authentication (MFA) with TOTP on Linux (Debian & RHEL Based)

This guide sets up **SSH Multi-Factor Authentication (MFA)** using **Time-Based One-Time Passwords (TOTP)** on Linux servers. It combines **SSH public key authentication** with a **rotating TOTP code** for enhanced SSH login security.

Tested on both **Debian-based** (Ubuntu, Debian) and **RHEL-based** (AlmaLinux, CentOS) systems.

---

## Features

- Two-factor authentication (2FA) via any TOTP-compatible app.
- SSH login requires both a public key and a time-based OTP.
- Modular configuration via: `/etc/ssh/sshd_config.d/10-totp-auth.conf`.
- Fully automated setup script.
- Safe rollback/reset instructions included.

---

## Prerequisites

- A Linux VM (Debian/Ubuntu or RHEL/AlmaLinux/CentOS).
- SSH public key-based access already configured.
- A TOTP app (Google / Microsoft / LastPass Authenticator, 1Password, etc).

Linux VM provisioning example: https://github.com/salmanwaheed/devops-projects/tree/release/vagrant-with-virtualbox

---

## Installation Instructions

1. **Copy the following files to your VM:**
   - `script.sh`
   - `totp-auth.conf` (TOTP config for SSH)

2. **Run the setup script:**
   ```sh
   chmod +x script.sh
   ./script.sh
   ```

   This script will:
   - Install required packages (`libpam-google-authenticator` or `google-authenticator`).
   - Initialize a TOTP secret for the current user.
   - Print a QR code to scan.
   - Configure SSH and PAM for 2FA.
   - Restart the SSH service.

---

## TOTP Setup

Once the script runs, you'll see a QR code and a secret key.

Scan it with any TOTP app:
- Google / Microsoft / LastPass Authenticator.
- 1Password.
- or any app that supports TOTP.

Ensure that 6-digit codes are rotating every 30 seconds.

---

## SSH Config File

TOTP-specific SSH settings are saved in:
```sh
/etc/ssh/sshd_config.d/10-totp-auth.conf
```

This approach avoids editing the main `sshd_config` directly and supports modular SSH configuration.

---

## Troubleshooting

```sh
sudo sshd -t # syntax check
sudo sshd -T | grep authentication # merged config
sudo journalctl -u sshd -f # live log during login test

```

## Reset or Remove MFA

To remove TOTP and restore the default SSH config:
```sh
# Debian/Ubuntu
sudo apt purge --autoremove openssh-server -y
sudo apt install openssh-server -y

# RHEL-based systems
sudo dnf remove openssh-server -y
sudo dnf install openssh-server -y

sudo rm -f /etc/ssh/sshd_config.d/10-totp-auth.conf
sudo systemctl enable sshd
sudo systemctl restart sshd
```

---

## References

- [DigitalOcean: SSH MFA Setup](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-18-04)
- [AWS Blog: Securing SSH Access](https://aws.amazon.com/blogs/startups/securing-ssh-to-amazon-ec2-linux-hosts/)
- [Ubuntu: Configure SSH with MFA](https://ubuntu.com/tutorials/configure-ssh-2fa#3-configuring-authentication)
