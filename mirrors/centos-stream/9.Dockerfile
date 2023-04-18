FROM quay.io/centos/centos:stream9
RUN dnf update -y
RUN dnf install -y util-linux
