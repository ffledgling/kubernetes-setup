#!/bin/bash

if [[ "$EUID" -eq 0 ]]
then
  echo "Please run this script as a regular user (fedora), not as root"
  exit 42
fi

# Copy over the admin kube-config, so we can use kubectl
mkdir -p $HOME/.kube
scp -r fedora@192.168.254.2:~/.kube/config $HOME/.kube/
