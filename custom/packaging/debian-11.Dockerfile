FROM debian:11

RUN apt update -y \
  && apt install -y apt-utils gnupg jq awscli python3 python3-venv \
    python3-pip build-essential devscripts debhelper bash-completion git
