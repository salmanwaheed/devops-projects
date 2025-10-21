# https://developer.hashicorp.com/terraform/language/functions/coalesce

locals {
  timezone      = coalesce(var.timezone, "Asia/Dubai")
  hostname      = coalesce(var.hostname, var.name) # var.hostname != "" ? var.hostname : var.name
  instance_id   = coalesce(var.instance_id, var.name)

  cloudinit_dir = pathexpand("${path.cwd}/cloudinit")
  pool_dir      = pathexpand("/var/lib/libvirt/tf-images")

  network_name  = "tf-network"
  network_cidr_block   = "172.31.60.0/24"
}
