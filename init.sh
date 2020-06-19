#!/bin/bash
pip install -e /salt
dbus-daemon --system --fork
virtlogd -d
libvirtd -d
salt-minion
