# Terraform Libvirt Instance Lab

This lab provisions a **KVM virtual machine** locally using **Terraform** and the **Libvirt provider**.
It uses **Cloud-Init** to automatically configure the hostname, users, and SSH keys.

**_Customize `terraform.tfvars` based on your requirements._**

---

## Directory Structure

```bash
terraform-libvirt-lab/
├── README.md
├── cloudinit/
│   ├── meta-data.yml   # Defines VM metadata
│   └── user-data.yml   # Defines VM user data
├── data-sources.tf     # Reads and renders cloud-init templates
├── locals.tf           # Sets reusable local values
├── main.tf             # Core logic (network, domain, pool, volumes)
├── provider.tf         # Connects Terraform to Libvirt (`qemu:///system`)
├── terraform.tfvars    # Contains variable values for this instance
├── variables.tf        # Declares variables for name, memory, vCPU, etc.
└── versions.tf         # Defines Terraform and provider versions
```

---

## How to Use

### 1. Prerequisites and Base Cloud Images

Follow the common virtualization setup and image download steps documented here:
[../setup-vms/kvm/README.md#prerequisites](../setup-vms/kvm/README.md#prerequisites)

---

### 2. Launch the Instance

```bash
terraform init
terraform apply
```

Once applied, the VM will be created under `/var/lib/libvirt/tf-images` (or your custom pool path).

**What happens:**
- Disk is copied from the base image.
- Cloud-init `user-data` and `meta-data` are rendered.
- A seed ISO is created with SSH keys and config.
- A new VM is defined and started.

---

### 3. Get the VM IP Address and SSH into the VM

Follow the instructions in:
[../setup-vms/kvm/README.md](../setup-vms/kvm/README.md)

---

## Networking

- **Mode:** `nat`
- **Default CIDR:** `172.31.60.0/24`

You can customize it in `locals.tf`:

```hcl
locals {
  network_name       = "my-net"
  network_cidr_block = "172.31.60.0/24"
}
```

---

## Useful virsh Commands

See detailed examples and advanced usage in:
[../setup-vms/kvm/README.md](../setup-vms/kvm/README.md)

---

## Cleanup

```bash
terraform destroy -auto-approve
```

---

## References

- https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs
- https://libvirt.org/formatnetwork.html
- https://cloudinit.readthedocs.io/en/latest
