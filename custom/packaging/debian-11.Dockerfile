FROM debian:11

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt update -y \
  && apt install -y apt-utils gnupg jq awscli python3 python3-venv python3-pip \
    build-essential devscripts debhelper bash-completion git patchelf curl

RUN export RUSTUP_HOME=/opt/rust \
  && export CARGO_HOME=/opt/rust \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

RUN for fname in $(ls /opt/rust/bin); do echo -e '#!/bin/sh\n\nRUSTUP_HOME=/opt/rust exec /opt/rust/bin/${0##*/} "$@"' > /usr/bin/$fname; chmod +x /usr/bin/$fname; done \
  && rustc --version
