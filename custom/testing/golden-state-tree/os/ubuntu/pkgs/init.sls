include:
  - os.debian.pkgs.apt-utils
  - os.debian.pkgs.libdpkg-perl
  - os.debian.pkgs.timesync
  - pkgs.bower
  - pkgs.sudo
  - pkgs.git
  - pkgs.cron
  - pkgs.curl
  - pkgs.dmidecode
  - pkgs.dnsutils
  # Some docker in docker tests fail on thses versions. The same tests pass on
  # debian-11 and ubuntu-20.04. These test also pass when locally but fail in
  # the CI/CD pipelines.
  {%- if grains['osrelease'] not in ['22.04', '24.04'] %}
  - pkgs.docker
  {%- endif %}
  - pkgs.file
  - pkgs.gcc
  - pkgs.gpg
  - pkgs.git
  - pkgs.ipset
  - pkgs.libcurl
  - pkgs.libffi
  - pkgs.libgit2
  - pkgs.libsodium
  - pkgs.libxml
  - pkgs.libxslt
  - pkgs.lxc
  - pkgs.make
  - pkgs.man
  - pkgs.nginx
  - pkgs.npm
  - pkgs.openldap
  - pkgs.openssl
  - pkgs.openssl-dev
  - pkgs.patch
  - pkgs.ping
  - pkgs.procps
  - pkgs.python3
  - pkgs.python3-pip
  - pkgs.python3-venv
  - pkgs.rng-tools
  - pkgs.rsync
  - pkgs.ssh
  - pkgs.sudo
  - pkgs.sed
  - pkgs.systemd
  - pkgs.swig
  - pkgs.tar
  - pkgs.zlib
  {%- if grains['osmajorrelease'] <= 22 %}
  {#- Newer OS targets don't require vault for CI/CD, as community salt extensions cover this #}
  - pkgs.vault
  {%- endif %}
  - pkgs.jq
  - pkgs.xz
  - pkgs.tree
  - pkgs.cargo {#-
#  - pkgs.awscli
#  - pkgs.amazon-cloudwatch-agent #}
  - pkgs.samba
