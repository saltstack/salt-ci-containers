FROM photon:4.0

RUN yum update -y \
  && yum install -y --allowerasing python3 python3-devel build-essential \
  python3-pip openssl git git jq createrepo curl wget
