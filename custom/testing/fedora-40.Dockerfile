FROM fedora:40

COPY golden-pillar-tree golden-pillar-tree
COPY golden-state-tree golden-state-tree

SHELL ["/bin/bash", "-c"]

RUN <<EOF
  set -e

  if [ $(uname -m) = "x86_64" ]; then
    export ARCH=x86_64
  else
    export ARCH=arm64
  fi

  yum update -y
  yum install -y curl wget tar xz patchelf openssl-pkcs11-sign-provider

  yum install -y make gcc

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$ARCH.tar.xz
  tar xf salt-3007.1-onedir-linux-$ARCH.tar.xz

  # ./salt/salt-call --log-level=debug --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision
  wget https://www.python.org/ftp/python/3.10.15/Python-3.10.15.tar.xz
  tar xf Python-3.10.15.tar.xz
  cd Python-3.10.15
  ./configure --enable-optimizations --prefix=/usr/local
  make

  rm -rf salt
  rm -rf salt-3007.1-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  rm -rf /var/log/salt
  rm -rf /var/cache/salt
  rm -rf /etc/salt
  rm -rf /tmp/*
EOF

CMD ["/bin/bash"]
