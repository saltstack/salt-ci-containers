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

  # QEMU arm64: ldconfig (libc-bin post-install) segfaults under emulation on
  # Debian 11's glibc 2.31. Replace with a no-op for the duration of the build.
  if [ "$ARCH" = "arm64" ]; then
    mv /sbin/ldconfig /sbin/ldconfig.real
    cp /bin/true /sbin/ldconfig
  fi

  # Debian 11 (bullseye) reached EOL on 2026-08-31. The live
  # debian-security repository InRelease signature is no longer refreshed
  # and packages have been purged from deb.debian.org, so `apt update` /
  # install fail with either "Release file ... is expired" or 404s on
  # package fetch. Pin sources to a snapshot.debian.org timestamp taken
  # a week before EOL -- this is the same set of snapshot URLs the base
  # debian:11 image already references (commented out) in its default
  # sources.list -- and install a persistent apt config that disables
  # the Valid-Until freshness check (so subsequent apt invocations from
  # Salt states also succeed). Scoped only to this dockerfile --
  # supported releases (Debian 12/13) must keep Valid-Until enforced as
  # a real security signal. GPG signature verification is unaffected.
  cat > /etc/apt/sources.list <<'SOURCES'
deb http://snapshot.debian.org/archive/debian/20260824T000000Z bullseye main
deb http://snapshot.debian.org/archive/debian-security/20260824T000000Z bullseye-security main
deb http://snapshot.debian.org/archive/debian/20260824T000000Z bullseye-updates main
SOURCES
  cat > /etc/apt/apt.conf.d/99-bullseye-eol <<'APTCONF'
Acquire::Check-Valid-Until "false";
Acquire::Retries "5";
Acquire::http::Timeout "60";
APTCONF
  apt-get update -y
  apt-get install -y tar wget xz-utils vim-nox apt-utils

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/$SALT_VERSION/salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz
  tar xf salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz

  # Ensure Salt can find its bundled libcrypto on ARM64. This is a workaround for a Salt bug where
  # rsax931.py ignores bundled libraries on Linux. We use a sed patch to avoid lookup failures.
  # This should go away after we have a proper fix in salt/utils/rsax931.py
  sed -i 's/lib = ctypes.util.find_library("crypto")/lib = (glob.glob(os.path.join(os.path.dirname(os.path.dirname(sys.executable)), "lib", "libcrypto.so*")) + [ctypes.util.find_library("crypto")])[0]/' ./salt/lib/python3.10/site-packages/salt/utils/rsax931.py

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision

  rm -rf salt
  rm -rf salt-$SALT_VERSION-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  # Restore ldconfig and rebuild the library cache. ldconfig itself can
  # segfault intermittently under QEMU arm64 emulation, so retry a few
  # times before giving up.
  if [ "$ARCH" = "arm64" ]; then
    mv /sbin/ldconfig.real /sbin/ldconfig
    for i in 1 2 3 4 5; do
      /sbin/ldconfig && break
      echo "ldconfig attempt $i failed, retrying..."
      sleep 1
    done
  fi

  rm -rf /var/log/salt
  rm -rf /var/cache/salt
  rm -rf /etc/salt
  rm -rf /tmp/*
  ln -s /bin/systemd /usr/lib/systemd/systemd
  apt-get clean
  rm -rf /var/cache/apt/archives/*
EOF

CMD ["/bin/bash"]
