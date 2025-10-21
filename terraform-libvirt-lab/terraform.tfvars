name = "al2023"

username           = "ec2-user"
password           = "123"
ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXkqUwXMXNS2mXgAMGHtNE3iPKyJogWdJcbyzjhwgS+HNCfcYr+YO431DNynKSevMG7tOKqKB23RiLA0s6gX7xQwZbdoW6jffxG45WfgIgpat5wIGkqCywJDk+B14lal9/X47QACwE2hCBXciA2PBpxOJopi2ybql8+I8oRgKsq9LNCfIyT9aEvkPRocSFKOtQv/BjcllM6swNVjUjMyTnhgIDA9amtcL6O+26A96M1ok21zuEXlfV5+hTmPQP7XVTD8VL+v8Mu61JMWJCi3vgj1Hqz6yaUTEY/xcbgB10CbYNn9Jdv3AR1Txvi1UrAkU7SvbtT5Eps/po0npgLEY7"

timezone      = null # default: Asia/Dubai
hostname      = null # default: var.name
instance_id   = null # default: var.name
volume_source = "~/Downloads/bootable-images/kvm/al2023-kvm-2023.9.20250929.0-kernel-6.1-x86_64.xfs.gpt.qcow2"

memory     = 2096
vcpu       = 2
autostart  = false
qemu_agent = true
