FROM amazonlinux:2

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units git gnupg2 jq createrepo rpm-sign epel-release rustc cargo \
    curl wget \
    && yum install -y patchelf
