#!/bin/bash

# Set SSH client port
if [[ -z "${SSH_PORT}" ]]; then
  SSH_PORT=2222
fi
echo "Port $SSH_PORT" >> /etc/ssh/ssh_config

# Set SSH server port
if [[ -z "${SSHD_PORT}" ]]; then
  SSHD_PORT=2222
fi
echo "Port $SSHD_PORT" >> /etc/ssh/sshd_config

# Set libvirt host UUID
if [[ -z "${HOST_UUID}" ]]; then
  HOST_UUID=2b1de640-a3fd-81e3-3d89-40167e11160e
fi
echo "host_uuid = \"$HOST_UUID\"" >> /etc/libvirt/libvirtd.conf

pip install -e /salt
/usr/sbin/sshd
virtlogd -d
libvirtd -d
salt-minion
