FROM quay.io/centos/centos:stream9

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release rustc cargo \
  && yum install -y patchelf \
  && yum install -y --allowerasing curl \
  && python3 -m pip install awscli
