#!/bin/bash

img_dir="$(dirname $(readlink -f $0))/images"
src_qcow="$HOME/VMs/originals/Fedora-Cloud-Base-28-1.1.x86_64.qcow2"
ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"

for i in {1..3}
do
  node="kube$i"
  img="$img_dir/$node.qcow2"
  iso="$img_dir/$node-cidata.iso" 

  rsync -avz "$src_qcow" "$img"

  cat << EOF > meta-data
instance-id: $node
local-hostname: $node
EOF

  cat << EOF > user-data
#cloud-config

password: fedora
chpasswd: { expire: False }
ssh_pwauth: True

ssh_authorized_keys:
    - ${ssh_pub_key}
runcmd:
  - [ sh, -xc, "echo 'nameserver 8.8.8.8' > /etc/resolv.conf" ]

final_message: "Custom cloud-config finished loading..."
EOF

# The dns servers should ideally be part of the network-config instead of
# user-data as explained here:
# http://cloudinit.readthedocs.io/en/latest/topics/network-config-format-v1.html#subnet-ip

# However, it appears there's a bug in cloud-init where this particular
# combination doesn't work specifically for our combination of cases (nocloud +
# fedora + dns config) - https://bugzilla.redhat.com/show_bug.cgi?id=1473890
#
# Talked to folks on #cloud-init, more bugs were filed -
# https://bugzilla.redhat.com/show_bug.cgi?id=1589972 TL;DR there's no real fix
# for the DNS issue, configure manually for now, leave the lines in so that
# when the fix arrives it's picked up automatically
cat << EOF > network-config
version: 1
config:
   - type: physical
     name: eth0
     subnets:
        - type: static
          address: 192.168.254.$((i + 1))
          netmask: 255.255.255.0
          gateway: 192.168.254.1
          dns_nameservers:
              - 8.8.8.8
              - 9.9.9.9
EOF

  genisoimage -output $iso -volid cidata -joliet -rock user-data meta-data network-config

  # Don't need sudo here anymore
  virt-install --import \
    --name $node \
    --ram 1024 \
    --vcpus 2 \
    --disk $img \
    --disk $iso,device=cdrom \
    --cpu host-passthrough \
    --nographics -v \
    --noautoconsole \
    --console pty,target_type=serial \
    --os-type linux \
    --network bridge=virbr1,model=virtio

done
