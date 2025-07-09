FROM rockylinux/rockylinux:9

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release \
  && yum install -y --allowerasing patchelf rustc cargo \
  && yum install -y --allowerasing curl \
  && python3 -m pip install awscli
