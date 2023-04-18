FROM quay.io/centos/centos:stream8
RUN dnf update -y
RUN dnf install -y util-linux
