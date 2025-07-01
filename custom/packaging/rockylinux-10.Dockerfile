FROM rockylinux/rockylinux:10

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release rustc cargo \
  && yum install -y patchelf rpmlint \
  && yum install -y --allowerasing curl \
  && python3 -m pip install awscli
