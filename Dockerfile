FROM python:3.7-alpine

RUN apk add --no-cache \
    gcc \
    g++ \
    autoconf \
    make \
    libffi-dev \
    openssl-dev \
    dbus \
    dnsmasq \
    gnutls \
    polkit \
    numactl \
    yajl \
    fuse \
    libpciaccess \
    parted \
    libssh \
    libxml2 \
    py3-libvirt \
    libvirt \
    libvirt-dev \
    libvirt-daemon \
    qemu-img \
    qemu

RUN echo "listen_tls = 0"     >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_tcp = 1'     >> /etc/libvirt/libvirtd.conf; \
    echo 'tls_port = "16514"' >> /etc/libvirt/libvirtd.conf; \
    echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf; \
    echo 'auth_tcp = "none"'  >> /etc/libvirt/libvirtd.conf; \
    mkdir -p /var/lib/libvirt/images/

RUN mkdir -p /salt /etc/pki /etc/salt/pki /etc/salt/minion.d/ /etc/salt/master.d /etc/salt/proxy.d /var/cache/salt /var/log/salt /var/run/salt
WORKDIR /salt

EXPOSE 4505 4506 8000 16509 16514 49152-49261

COPY init.sh /init.sh
CMD ["/init.sh"]
