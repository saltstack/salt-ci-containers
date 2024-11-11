# Install dnf config manager
install_config_command:
  cmd.run:
    - name: dnf install -y 'dnf-command(config-manager)'


# Use config manager to enable powertools repo. This is needed for libnsl2-devel
enable_powertools_repo:
  cmd.run:
    - name: dnf config-manager --set-enabled powertools
    - require:
      - install_config_command


python_dependencies:
   pkg.latest:
     - pkgs:
       - gcc
       - make
       - findutils
       - openssl-devel
       - libffi-devel
       - bzip2-devel
       - zlib-devel
       - libuuid-devel
       - readline-devel
       - ncurses-devel
       - gdbm-devel
       - sqlite-devel
       - xz-devel
       - libnsl2-devel
     - require:
       - enable_powertools_repo
