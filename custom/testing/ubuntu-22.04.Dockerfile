FROM ubuntu:22.04 as build

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY golden-pillar-tree golden-pillar-tree
COPY golden-state-tree golden-state-tree

RUN apt update -y \
  && echo 'tzdata tzdata/Areas select America' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
#    python3 python3-venv python3-pip unzip sudo tree \
  tar wget xz-utils vim-nox apt-utils \
  && wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$(uname -m).tar.xz \
  && tar xvf salt-3007.1-onedir-linux-$(uname -m).tar.xz \
  && ./salt/salt-call --local --pillar-root=/golden-pillar-tree --file-root=/golden-state-tree state.apply provision \
  && rm -rf salt \
  && rm -rf salt-3007.1-onedir-linux-$(uname -m).tar.xz \
  && rm -rf golden-pillar-tree \
  && rm -rf golden-state-tree
