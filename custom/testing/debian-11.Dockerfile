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

  echo 'tzdata tzdata/Areas select America' | debconf-set-selections
  echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections

  export DEBIAN_FRONTEND="noninteractive"

  apt update -y
  apt install -y tar wget xz-utils vim-nox apt-utils

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/$SALT_VERSION/salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz
  tar xf salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz

  # Ensure Salt can find its bundled libcrypto on ARM64. This is a workaround for a Salt bug where
  # rsax931.py ignores bundled libraries on Linux. We use a sed patch to avoid lookup failures.
  # This should go away after we have a proper fix in salt/utils/rsax931.py
  sed -i 's/lib = ctypes.util.find_library("crypto")/lib = (glob.glob(os.path.join(os.path.dirname(os.path.dirname(sys.executable)), "lib", "libcrypto.so*")) + [ctypes.util.find_library("crypto")])[0]/' ./salt/lib/python3.10/site-packages/salt/utils/rsax931.py

  # On ARM64 under QEMU, ldconfig segfaults when triggered by package post-install scripts
  # (e.g. libc-bin triggers fired by systemd/openssh-server). Stub it out for the Salt run
  # and restore it afterward so the final image retains a working ldconfig at runtime.
  # Debian 11 uses non-merged-usr so ldconfig is at /sbin/ldconfig, not /usr/sbin/ldconfig.
  if [ "$(uname -m)" != "x86_64" ]; then
    _ldconfig=$(command -v ldconfig 2>/dev/null || true)
    if [ -n "$_ldconfig" ]; then
      cp "$_ldconfig" "${_ldconfig}.real"
      printf '#!/bin/sh\nexit 0\n' > "$_ldconfig"
    fi
  fi

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision

  for _ldconfig_real in /usr/sbin/ldconfig.real /sbin/ldconfig.real; do
    if [ -f "$_ldconfig_real" ]; then
      mv "$_ldconfig_real" "${_ldconfig_real%.real}"
    fi
  done

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
