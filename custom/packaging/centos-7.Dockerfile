FROM centos:7

RUN yum update -y \
  && yum -y install python3 python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo \
  && python3 -m pip install awscli
