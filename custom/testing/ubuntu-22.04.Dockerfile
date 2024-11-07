FROM ubuntu:22.04

RUN apt update -y \
  && echo 'tzdata tzdata/Areas select America' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
    python3 python3-venv python3-pip unzip sudo tree \
    wget systemd \

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log
COPY /log /log
