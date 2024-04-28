FROM ubuntu:22.04

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt update -y \
  && echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/Europe select Lisbon' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
    apt-utils gnupg jq awscli python3 python3-venv python3-pip \
    build-essential devscripts debhelper bash-completion git patchelf curl rustc
