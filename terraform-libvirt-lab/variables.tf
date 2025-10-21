variable "name" {}
variable "username" {}
variable "password" {}
variable "ssh_authorized_key" {}
variable "timezone" {}
variable "hostname" {}
variable "instance_id" {}
variable "volume_source" {}
variable "memory" { type = number }
variable "vcpu" { type = number }
variable "autostart" { type = bool }
variable "qemu_agent" { type = bool }
