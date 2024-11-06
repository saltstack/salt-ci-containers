FROM fedora:40

RUN yum update -y \
  && yum install -y --allowerasing python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign rustc cargo \
    curl wget patchelf
