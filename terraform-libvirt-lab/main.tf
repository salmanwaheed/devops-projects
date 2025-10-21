# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs
# https://github.com/dmacvicar/terraform-provider-libvirt

resource "libvirt_pool" "main" {
  name = basename(local.pool_dir)
  type = "dir"

  target {
    path = local.pool_dir
  }
}

resource "libvirt_volume" "main" {
  name   = "${var.name}.qcow2"
  pool   = libvirt_pool.main.name # virsh pool-list
  format = "qcow2"
  source = pathexpand(var.volume_source)
}

resource "libvirt_cloudinit_disk" "main" {
  name      = "${var.name}-seed.io"
  pool      = libvirt_pool.main.name # virsh pool-list
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
}

# mode can be: "nat" (default), "none", "route", "open", "bridge"
# for bridge network, qemu-agent must be installed / enabled
resource "libvirt_network" "main" {
  name      = local.network_name
  mode      = "nat"
  autostart = true
  addresses = [local.network_cidr_block]

  dhcp {
    enabled = true
  }
}

resource "libvirt_domain" "main" {
  name       = var.name
  memory     = var.memory
  vcpu       = var.vcpu
  autostart  = var.autostart
  qemu_agent = var.qemu_agent
  type       = "kvm"

  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.main.id

  network_interface {
    network_id     = libvirt_network.main.id
    wait_for_lease = false
  }

  disk {
    volume_id = libvirt_volume.main.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  # console {
  #   type        = "pty"
  #   target_type = "virtio"
  #   target_port = "1"
  # }

  # graphics {
  #   type        = "spice"
  #   listen_type = "address"
  #   autoport    = true
  # }
}
