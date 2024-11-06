FROM photon:5.0

RUN yum update -y \
  && yum install -y --allowerasing python3 python3-devel python3-pip \
    build-essential openssl git git jq createrepo curl wget
