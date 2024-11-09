FROM fedora:40

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
  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision
  rm -rf salt
  rm -rf salt-3007.1-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree
EOF

CMD ["/bin/bash"]
