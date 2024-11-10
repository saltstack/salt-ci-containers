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

# XXX: Force shell to tty1 verify this works.
# RUN echo "systemd.debug_shell=tty1" >> /etc/sysctl.conf

# XXX: Override the rescue service. It would be better to not tamper with this
# and instead create our own service. That requires working out wants and such
# to make everything work correctly.
COPY rescue.service /etc/systemd/system/rescue.service.d/override.conf


# We've renamed /usr/bin/tail to /usr/bin/tail.real Now put our shim tail in
# place. This is needed because github actions always set the container's
# entrypoint to 'tail'. Our tail shim will launch systemd if it's pid is 1,
# essentially doing the same thing as entrypoint.py. When pid is not 1 we just
# run tail.
COPY tail /usr/bin/tail

RUN chmod +x /usr/bin/tail

ENTRYPOINT [ "/entrypoint.py" ]
CMD [ "/bin/bash" ]
