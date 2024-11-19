FROM photon:5.0

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

  tdnf update -y
  tdnf install -y curl wget tar xz  # patchelf

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

  mv /usr/bin/tail /usr/bin/tail.real
EOF

COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf
COPY tail /usr/bin/tail
COPY entrypoint.py /entrypoint.py
RUN chmod +x /usr/bin/tail /entrypoint.py

ENTRYPOINT [ "/entrypoint.py" ]
CMD ["/bin/bash"]
