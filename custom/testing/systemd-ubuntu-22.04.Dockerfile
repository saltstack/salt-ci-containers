FROM ubuntu:22.04

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY entrypoint.py entrypoint.py

# init and systemd are the only real requirements for systemd.
#
# tar wget x-utils can be used to fetch and extract a salt onedir.
#
# apt-utils was required by golden states, this may/should be fixed in those
# states.
#
# tree is used by workflows for debugging
#
# coreutils provides tail
RUN apt update -y \
  && echo 'tzdata tzdata/Areas select America' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/America select Phoenix' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt install -y \
  coreutils tree tar wget xz-utils apt-utils systemd python3 python3-pip python3-venv git \
  && chmod +x entrypoint.py \
  && mv /usr/bin/tail /usr/bin/tail.real

# Set the root password, this was done before single user mode worked.
# RUN echo "root\nroot" | passwd -q root
# RUN echo "systemd.debug_shell=tty1" >> /etc/sysctl.conf
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf
COPY tail /usr/bin/tail

RUN chmod +x /usr/bin/tail

ENTRYPOINT [ "/entrypoint.py" ]
CMD [ "/bin/bash" ]
