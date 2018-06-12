#!/bin/bash

# Docker is the de-facto run-time for now, maybe we'll try kata or gvisor later

# Don't use these instructions... we need docker-ce from upstream docker.
##sudo dnf install -y docker
##sudo systemctl enable docker && systemctl start docker

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
# We enable the edge repo, because at the time of writing docker hasn't
# released any packages for fedora-28 in stable. See https://github.com/docker/for-linux/issues/295
sudo dnf config-manager --set-enabled docker-ce-edge
sudo dnf install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Kubelet doesn't like this
setenforce 0

# Install the components and enable them
dnf install -y kubelet kubeadm kubectl
sudo sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl enable kubelet && systemctl start kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
