#!/bin/bash

# Set libvirt TCP port
if [[ -z "${LIBVIRT_TCP_PORT}" ]]; then
  LIBVIRT_TCP_PORT=16509
fi
echo "tcp_port = \"$LIBVIRT_TCP_PORT\"" >> /etc/libvirt/libvirtd.conf

# Set libvirt TLS port
if [[ -z "${LIBVIRT_TLS_PORT}" ]]; then
  LIBVIRT_TLS_PORT=16514
fi
echo "tls_port = \"$LIBVIRT_TLS_PORT\"" >> /etc/libvirt/libvirtd.conf

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

env USE_STATIC_REQUIREMENTS=1 pip3 install -e /salt
/usr/sbin/sshd
virtlogd -d

if [[ -z "${NO_START_MINION}" ]]; then
    libvirtd --listen -d
    salt-minion
else
    libvirtd --listen
fi
