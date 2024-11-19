FROM amazonlinux:2

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
  yum install -y wget tree tar xz patchelf util-linux openssl openssl-pkcs11

  wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$ARCH.tar.xz
  tar xf salt-3007.1-onedir-linux-$ARCH.tar.xz

  ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply python

  rm -rf salt
  rm -rf salt-3007.1-onedir-linux-$ARCH.tar.xz
  rm -rf golden-pillar-tree
  rm -rf golden-state-tree

  mv /usr/bin/tail /usr/bin/tail.real
EOF

COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf
COPY tail /usr/bin/tail
COPY entrypoint.py /entrypoint.py
RUN chmod +x /usr/bin/tail /entrypoint.py

ENTRYPOINT [ "/entrypoint.py" ]
CMD ["/bin/bash"]
