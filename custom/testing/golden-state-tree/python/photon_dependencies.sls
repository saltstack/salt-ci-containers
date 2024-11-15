{#-
#}

install_rpm_for_py:
  cmd.run:
    - name: tdnf install -y rpm
    - if_missing: /usr/bin/rpm
    - order: 0

coreutils:
   pkg.installed:
    - name: coreutils-selinux
    - requires:
      - install_rpm_for_py

python_dependencies:
   pkg.latest:
     - pkgs:
       - gcc
       - make
       - findutils
       - binutils
       - build-essential
       - pkg-config
       - openssl-devel
       - libffi-devel
       - bzip2-devel
       - zlib-devel
       - readline-devel
       - ncurses-devel
       - gdbm-devel
       - sqlite-devel
       - xz-devel
       - expat-devel
       - util-linux-devel
       - libnsl-devel
       - iana-etc
       - tzdata
       - curl-devel
     - require:
       - coreutils
