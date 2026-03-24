FROM debian:11

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
  export SALT_VERSION=3007.13

  # Workaround for QEMU segfaults on Debian 11 ARM64 during ldconfig.
  # We do this at the very beginning to avoid crashes during apt install.
  if [ "$ARCH" = "arm64" ]; then
    mv /sbin/ldconfig /sbin/ldconfig.real
    echo -e '#!/bin/sh\nexit 0' > /sbin/ldconfig
    chmod +x /sbin/ldconfig
  fi

  echo 'tzdata tzdata/Areas select America' | debconf-set-selections
  echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections

  export DEBIAN_FRONTEND="noninteractive"

  apt update -y
  apt install -y tar wget xz-utils vim-nox apt-utils

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/$SALT_VERSION/salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz
  tar xf salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz

  # Ensure Salt can find its bundled libcrypto on ARM64. This is a workaround for a Salt bug where
  # rsax931.py ignores bundled libraries on Linux. We use a sed patch instead of ldconfig to
  # avoid segmentation faults in QEMU/buildx environments.
  # This should go away after we have a proper fix in salt/utils/rsax931.py
  sed -i 's/lib = ctypes.util.find_library("crypto")/lib = (glob.glob(os.path.join(os.path.dirname(os.path.dirname(sys.executable)), "lib", "libcrypto.so*")) + [ctypes.util.find_library("crypto")])[0]/' ./salt/lib/python3.10/site-packages/salt/utils/rsax931.py

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision

  # Restore real ldconfig
  if [ "$ARCH" = "arm64" ]; then
    mv /sbin/ldconfig.real /sbin/ldconfig
    /sbin/ldconfig
  fi

  rm -rf salt
  rm -rf salt-3007.6-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  rm -rf /var/log/salt
  rm -rf /var/cache/salt
  rm -rf /etc/salt
  rm -rf /tmp/*
  ln -s /bin/systemd /usr/lib/systemd/systemd
  apt-get clean
  rm -rf /var/cache/apt/archives/*
EOF

CMD ["/bin/bash"]
