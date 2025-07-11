FROM ubuntu:24.04

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
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

  echo 'tzdata tzdata/Areas select America' | debconf-set-selections
  echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections

  export DEBIAN_FRONTEND="noninteractive"

  apt update -y
  apt install -y tar wget xz-utils vim-nox apt-utils
  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.6/salt-3007.6-onedir-linux-$ARCH.tar.xz
  tar xf salt-3007.6-onedir-linux-$ARCH.tar.xz

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision

  rm -rf salt
  rm -rf salt-3007.6-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  rm -rf /var/log/salt
  rm -rf /var/cache/salt
  rm -rf /etc/salt
  rm -rf /tmp/*
  apt-get clean
  rm -rf /var/cache/apt/archives/*
EOF

CMD ["/bin/bash"]
