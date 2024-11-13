{#-
#}

coreutils:
   pkg.installed:
    - name: coreutils-selinux

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
     - require:
       - coreutils
