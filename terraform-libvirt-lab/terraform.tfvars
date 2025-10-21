name = "<vm-name>"

username           = "<username>"
password           = "<password>"
ssh_authorized_key = "ssh-rsa xxxxxxxxxxx"

timezone      = null # default: Asia/Dubai
hostname      = null # default: var.name
instance_id   = null # default: var.name
volume_source = "~/Downloads/bootable-images/kvm/<FILE_NAME>.qcow2"

memory     = 2096
vcpu       = 2
autostart  = false
qemu_agent = true
