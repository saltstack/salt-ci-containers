FROM fedora:32

RUN dnf update -y && \
    dnf install -y --setopt=tsflags=nodocs --setopt=install_weak_deps=False \
      libvirt-daemon-driver-qemu \
      libvirt-daemon-driver-storage-core \
      libvirt-client \
      qemu-kvm \
      qemu-img \
      selinux-policy \
      selinux-policy-targeted \
      nftables \
      iptables \
      libgcrypt \
      python3 \
      python3-pip \
      python3-libvirt && \
    dnf clean all && \
    pip3 install --no-cache-dir \
      msgpack==0.5.6 \
      requests \
      distro \
      pycryptodomex \
      MarkupSafe \
      Jinja2 \
      pyzmq \
      PyYAML \
      urllib3 \
      chardet \
      certifi

RUN echo 'listen_tls = 0'     >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_tcp = 1'     >> /etc/libvirt/libvirtd.conf; \
    echo 'tls_port = "16514"' >> /etc/libvirt/libvirtd.conf; \
    echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf; \
    echo 'auth_tcp = "none"'  >> /etc/libvirt/libvirtd.conf; \
    mv /etc/libvirt/qemu/networks/autostart/default.xml /etc/libvirt/qemu/networks/autostart/default.xml.disabled; \
    mkdir -p /var/lib/libvirt/images /salt

WORKDIR /salt

ADD http://tinycorelinux.net/11.x/x86/release/Core-current.iso /var/lib/libvirt/images/
COPY init.sh /init.sh
COPY core-vm.xml /core-vm.xml
CMD [ "/init.sh" ]
