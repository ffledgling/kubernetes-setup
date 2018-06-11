About
-----

Just a document of useful links that I've accumulated and are otherwise hard to find:

Meat
----

Getting a raw image working without having to manually install a distro:
* <https://goldmann.pl/blog/2014/01/16/running-fedora-cloud-images-on-kvm/>
* <https://spinningmatt.wordpress.com/2014/01/08/a-recipe-for-starting-cloud-images-with-virt-install/>
* OG Makefile I wrote - <https://gist.github.com/ffledgling/27460a617f0e9ef93afd847b6ef3c20a>

How to run virt in userspace, but piggyback on networking from libvirt's default network:
* <http://ixday.github.io/post/unprivileged_libvirt/>

Networking setup (eventually did not use, but useful for dhcp config of libvirt):
* <https://www.berrange.com/posts/2013/03/01/installing-a-4-node-fedora-18-openstack-folsom-cluster-with-packstack/>

Setup cloud-init for "nocloud" correctly, especially networking:
* Fedora specifc - <https://www.projectatomic.io/blog/2014/10/getting-started-with-cloud-init/>
* offical docs - <http://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html#datasource-nocloud>
* network-config needs to be a separate file - <https://gist.github.com/Informatic/0b6b24374b54d09c77b9d25595cdbd47>
* network config format - <http://cloudinit.readthedocs.io/en/latest/topics/network-config-format-v1.html>
* user-data requires `#cloud-config` at the top, otherwise throws misleading encoding errors - <https://github.com/hashicorp/terraform/issues/7063#issuecomment-382274222>

