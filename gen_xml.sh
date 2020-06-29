#!/bin/sh
virt-install \
	--connect qemu:///system \
	--name=core-vm \
	--vcpus=1 \
	--memory=256 \
	--graphics none \
	--disk none \
	--noautoconsole \
	--os-variant=generic \
	--print-xml \
	--dry-run \
	--cdrom /var/lib/libvirt/images/Core-current.iso
