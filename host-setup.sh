#!/bin/bash
set -x

# This is written against Fedora 27

########################################

# Utilify functions

error() {
  echo "$@" >&2
  exit 1
}

########################################

# Basically just following the guide from:
# https://docs.fedoraproject.org/quick-docs/en-US/getting-started-with-virtualization.html

sudo dnf install @virtualization
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# Check our kvm module is loaded
if [[ "(lsmod | grep kvm | awk '{print $1}' | grep '^kvm')" == "" ]]
then
  error "kvm module not loaded"
fi

# Networking bits taken from: https://wiki.libvirt.org/page/Networking

# Enable ipv4 forwarding
if ! grep 'net.ipv4.ip_forward = 1' /etc/sysctl.conf;
then
  sudo sed '/net.ipv4.ip_forward/d' /etc/sysctl.conf
  echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
fi

# Add virbr1 interface, which we create for the kubernetes network, to the list
# of networks VMs can use without running as root. Otherwise it returns a
# qemu-bridge-helper error
if ! grep 'allow virbr1' /etc/qemu/bridge.conf
then
  echo "allow virbr1" | sudo tee -a /etc/qemu/bridge.conf
fi

# Setup virsh networking, these need root because it creates bridge interfaces
# on the host:
sudo virsh net-define kubernetes.xml
sudo virsh net-autostart kubernetes
sudo virsh net-start kubernetes

