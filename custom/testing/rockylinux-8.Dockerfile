FROM rockylinux:8

RUN yum update -y \
  && yum install -y --alowerasing python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release rustc cargo \
  patchelf curl wget
