data "template_file" "user_data" {
  template = templatefile("${local.cloudinit_dir}/user-data.yml", {
    timezone           = local.timezone
    username           = var.username
    password           = var.password
    ssh_authorized_key = var.ssh_authorized_key
  })
}

data "template_file" "meta_data" {
  template = templatefile("${local.cloudinit_dir}/meta-data.yml", {
    instance_id = local.instance_id
    hostname    = local.hostname
  })
}
