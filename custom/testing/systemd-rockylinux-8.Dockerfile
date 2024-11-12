FROM rockylinux:8

COPY golden-pillar-tree golden-pillar-tree
COPY golden-state-tree golden-state-tree

RUN <<EOF
  if [ $(uname -m) = "x86_64" ]; then
    export ARCH=x86_64
  else
    export ARCH=arm64
  fi
  yum update -y
  yum install -y epel-release
  yum install -y curl wget tar xz patchelf
  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$ARCH.tar.xz
  tar xf salt-3007.1-onedir-linux-$ARCH.tar.xz
  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply python
  rm -rf salt
  rm -rf salt-3007.1-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree
  mv /usr/bin/tail /usr/bin/tail.real
EOF

COPY tail /usr/bin/tail
COPY entrypoint.py entrypoint.py
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf
RUN chmod +x /entrypoint.py /usr/bin/tail

ENTRYPOINT [ "/entrypoint.py" ]
CMD ["/bin/bash"]
