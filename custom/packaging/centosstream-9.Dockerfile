FROM quay.io/centos/centos:stream9

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release \
  && yum install -y patchelf \
  && yum install -y --allowerasing curl \
  && python3 -m pip install awscli

RUN export RUSTUP_HOME=/opt/rust \
  && export CARGO_HOME=/opt/rust \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

RUN for fname in $(ls /opt/rust/bin); do echo -e '#!/bin/sh\n\nRUSTUP_HOME=/opt/rust exec /opt/rust/bin/${0##*/} "$@"' > /usr/bin/$fname; chmod +x /usr/bin/$fname; done \
  && rustc --version
