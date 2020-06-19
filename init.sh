#!/bin/bash
pip install -e /salt
virtlogd -d
libvirtd -d
salt-minion
