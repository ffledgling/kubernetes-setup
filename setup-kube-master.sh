#!/bin/bash

# We install flannel, following instructions here:
# https://github.com/coreos/flannel/blob/master/Documentation/kubernetes.md

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Enable pod scheduling on the master as well. Disabled by default.
# kubectl taint nodes --all node-role.kubernetes.io/master-
