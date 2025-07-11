# VirtualBox Kernel Module Signing & Secure Boot Fix (Ubuntu)

This guide helps you enable VirtualBox to work properly with **Secure Boot** by signing its kernel modules using a Machine Owner Key (MOK).

## Features

- Automatically installs required packages: `virtualbox`, `mokutil`, `zstd`, and kernel headers.
- Automatically generates and imports a Machine Owner Key (MOK) pair (`MOK.der` and `MOK.priv`).
- Signs VirtualBox DKMS kernel modules (`vboxdrv`, `vboxnetflt`, `vboxnetadp`).
- Requires a reboot to complete MOK enrollment.

---

## Step 1: Before Reboot

```sh
chmod +x before-reboot.sh
before-reboot.sh
```

This script will:
- Install required packages.
- Generate a new key pair.
- Import the MOK.
- Prompt for reboot and enrollment.

You will be asked to **enter a one-time password** (not your system password). This will be used to **enroll the MOK after reboot**.

---

## Step 2: Reboot & Enroll Key

After running `before-reboot.sh`, **reboot your system**:

```sh
sudo reboot
```

You will see a **blue screen** called **MOK Manager**. Follow these steps:

1. Use arrow keys to select: `Enroll MOK`.
2. Choose: `Continue`.
3. Enter the password you created earlier.
4. Select: `Yes` to confirm enrollment.
5. Reboot again.

If you **miss this screen or skip enrollment**, Secure Boot will **still reject your modules**, even if they are signed.

In that case, **you must run `before-reboot.sh` again**, re-import the key, and **reboot once more**.

---

## Step 3: After Reboot (Sign and Load Modules)

After enrollment is complete:

```sh
chmod +x after-reboot.sh
after-reboot.sh
```

This script will:
- Decompress the `.ko.zst` VirtualBox modules.
- Sign each module using your enrolled key.
- Attempt to load modules using `modprobe`.
- Verify that they are signed.
- Restart virtualbox.

---

## Troubleshooting

### Signed but still fails with: `modprobe: ERROR: could not insert 'vboxdrv': Key was rejected by service`

This usually means:
- You **skipped MOK enrollment after reboot**.
- The module was **signed with a different key** than what was enrolled.

**Fix**:
- Re-run `before-reboot.sh`.
- Reboot again and **make sure to complete MOK enrollment**.
- Then re-run `after-reboot.sh`.

---

## Helpful Commands (Manual Checks)

```sh
# Verify signed modules
modinfo vboxdrv | grep signer
modinfo vboxnetflt | grep signer
modinfo vboxnetadp | grep signer
# modinfo /usr/lib/modules/$(uname -r)/updates/dkms/vboxdrv.ko | grep signer
# modinfo /usr/lib/modules/$(uname -r)/updates/dkms/vboxnetflt.ko | grep signer
# modinfo /usr/lib/modules/$(uname -r)/updates/dkms/vboxnetadp.ko | grep signer

# Check Secure Boot status
mokutil --sb-state

# List enrolled keys
mokutil --list-enrolled | grep -A 1 'VirtualBox'
```

---

## References

- [Ubuntu UEFI Secure Boot Wiki](https://wiki.ubuntu.com/UEFI/SecureBoot)
- [VirtualBox Linux Host Kernel Module Signing](https://www.virtualbox.org/manual/ch02.html#idp55397200)
