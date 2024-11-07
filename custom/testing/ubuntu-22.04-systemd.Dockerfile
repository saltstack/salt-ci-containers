FROM ubuntu:22.04 as build

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt update -y \
  && echo 'tzdata tzdata/Areas select America' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
#    python3 python3-venv python3-pip unzip sudo tree \
  tar wget xz-utils vim-nox apt-utils init systemd \
  && wget https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-$(uname -m).tar.xz \
  && tar xvf salt-3007.1-onedir-linux-$(uname -m).tar.xz


RUN ./salt/salt --versions-report > /versions.txt

# RUN  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done)  \
# && rm -f /lib/systemd/system/multi-user.target.wants/* \
# && rm -f /etc/systemd/system/*.wants/* \
# && rm -f /lib/systemd/system/local-fs.target.wants/* \
# && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
# && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
# && rm -f /lib/systemd/system/basic.target.wants/* \
# && rm -f /lib/systemd/system/anaconda.target.wants/*;


RUN echo "root\nroot" | passwd -q root

RUN echo "single" >> /etc/sysctl.conf
RUN echo "systemd.debug_shell=tty1" >> /etc/sysctl.conf
#COPY golden-pillar-tree golden-pillar-tree
#COPY golden-state-tree golden-state-tree
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf

CMD [ "/sbin/init", "1" ]
