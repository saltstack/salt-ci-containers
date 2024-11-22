FROM ubuntu:22.04

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

  apt update -y
  echo 'tzdata tzdata/Areas select America' | debconf-set-selections
  echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections
  export DEBIAN_FRONTEND="noninteractive"
  apt install -y coreutils tree tar wget xz-utils apt-utils systemd python3 \
    python3-pip python3-venv git systemd

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$ARCH.tar.xz
  tar xf salt-3007.1-onedir-linux-$ARCH.tar.xz

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply python

  rm -rf salt
  rm -rf salt-3007.1-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  rm -rf /var/log/salt
  rm -rf /var/cache/salt
  rm -rf /etc/salt
  rm -rf /tmp/*

  mv /usr/bin/tail /usr/bin/tail.real
EOF

# Set the root password, this was done before single user mode worked.
# RUN echo "root\nroot" | passwd -q root

# XXX: Force shell to tty1 verify this works.
# RUN echo "systemd.debug_shell=tty1" >> /etc/sysctl.conf

# XXX: Override the rescue service. It would be better to not tamper with this
# and instead create our own service. That requires working out wants and such
# to make everything work correctly.
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf


# We've renamed /usr/bin/tail to /usr/bin/tail.real Now put our shim tail in
# place. This is needed because github actions always set the container's
# entrypoint to 'tail'. Our tail shim will launch systemd if it's pid is 1,
# essentially doing the same thing as entrypoint.py. When pid is not 1 we just
# run tail.
COPY tail /usr/bin/tail
COPY entrypoint.py /entrypoint.py
RUN chmod +x /usr/bin/tail /entrypoint.py

ENTRYPOINT [ "/entrypoint.py" ]
CMD [ "/bin/bash" ]
