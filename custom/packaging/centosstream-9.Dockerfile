FROM quay.io/centos/centos:stream9

RUN yum update -y \
  && yum install -y python3 python3-devel python3-pip openssl git rpmdevtools rpmlint \
    systemd-units libxcrypt-compat git gnupg2 jq createrepo rpm-sign epel-release \
  && yum install -y patchelf \
  && yum install -y --allowerasing curl \
  && python3 -m pip install awscli

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path \
  && for fpath in $(ls /root/.cargo/bin/); do mv /root/.cargo/bin/$fpath /bin/$fpath; done \
  && rustc --version
