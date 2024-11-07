FROM ubuntu:22.04 as build

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt update -y \
  && echo 'tzdata tzdata/Areas select America' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
  tar wget xz-utils vim-nox apt-utils init systemd


RUN ./salt/salt --versions-report > /versions.txt

# Set the root password, this was done before single user mode worked.
# RUN echo "root\nroot" | passwd -q root
RUN echo "systemd.debug_shell=tty1" >> /etc/sysctl.conf
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf

CMD [ "/sbin/init", "1" ]
