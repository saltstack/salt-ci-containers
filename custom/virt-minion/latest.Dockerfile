# Since 3006.x does not have Py3.11 linux requirements files, we need to stay on
# Fedora 36 so that we install Salt under Py3.10
FROM registry.fedoraproject.org/fedora:36

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
      nc \
      openssh-server \
      openssh-clients \
      make \
      automake \
      gcc \
      gcc-c++ \
      rustc \
      cargo \
      libffi-devel \
      python3 \
      python3-devel \
      python3-pip \
      python3-psutil \
      python3-libvirt && \
    dnf clean all

RUN env USE_STATIC_REQUIREMENTS=1 pip3 install --no-cache-dir salt

RUN echo 'listen_tls = 1'     >> /etc/libvirt/libvirtd.conf; \
    echo 'listen_tcp = 1'     >> /etc/libvirt/libvirtd.conf; \
    echo 'auth_tcp = "none"'  >> /etc/libvirt/libvirtd.conf; \
    # Disable default libvirt network \
    rm -f /etc/libvirt/qemu/networks/autostart/default.xml; \
    # SSH login fix. Otherwise user is kicked off after login \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    mkdir -p /var/lib/libvirt/images /etc/pki/libvirt/private /etc/pki/CA /salt /root/.ssh

WORKDIR /salt

ADD http://tinycorelinux.net/11.x/x86/release/Core-current.iso /var/lib/libvirt/images/
COPY init.sh /init.sh
COPY core-vm.xml /core-vm.xml
COPY ssh/id_rsa /root/.ssh/id_rsa
COPY ssh/id_rsa /etc/ssh/ssh_host_rsa_key
COPY ssh/id_rsa.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh/id_rsa.pub /root/.ssh/id_rsa.pub
COPY ssh/id_rsa.pub /root/.ssh/authorized_keys
COPY ssh/known_hosts /root/.ssh/known_hosts
COPY pki/servercert.pem /etc/pki/libvirt/
COPY pki/clientcert.pem /etc/pki/libvirt/
COPY pki/serverkey.pem /etc/pki/libvirt/private/
COPY pki/clientkey.pem /etc/pki/libvirt/private/
COPY pki/cacert.pem /etc/pki/CA/
RUN chmod 400 /etc/ssh/ssh_host_rsa_key \
	      /root/.ssh/id_rsa \
	      /root/.ssh/authorized_keys \
	      /etc/pki/libvirt/private/serverkey.pem \
	      /etc/pki/libvirt/private/clientkey.pem
CMD [ "/init.sh" ]
