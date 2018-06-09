Project:
-------

Setup a local kubernetes cluster.

Design:
------

* At least 3 Kubernetes Nodes. Running as QEMU/KVM virtual machines (for now).
* +1 Node outside of Kubernetes, use this as our proxy server, network gateway, DHCP server (if needed), PXE Server, etc.
* OS: TBD - Toss up between Ubuntu, CentOS7 and CoreOS.
* Storage: No persistent storage at the start.
* Networking: Initial pass should just have a simple Bridge network connecting all 4 nodes.
* Config: We need to manage the configs somehow, start out with simple
  cloud-config + libvirt configs
* Provisioning: Initial installs will be by hand.


General Idea:
------------

We don't want to get bogged down by too many details and get
distracted by too many shiny things upfront. There are only two
things we really care about:

1. The cluster should be cheap, easy, and fast to build, teardown, and rebuild.
2. The cluster should be reproducable. The configs and
   everything should bring up a cluster out of a fresh clone of
   the repo.

Iterations
----------

Things I'd like to change up and try over the next couple of cycles:

* Hypervisor: Try proxmox instead of QEMU/kvm
* OS: Play around with more operating systems.
* Storage: In-cluster glusterfs and/or Ceph.
* Networking: More complicated networking topologies, to mirror
  data-center like setups more closely, also to test things like
  Metallb.
* Config: Get to a point where everything is ansible/puppet/salt
  managed.
* Provisioning: Try out digital rebar and pixiecore to see how
  it goes.
