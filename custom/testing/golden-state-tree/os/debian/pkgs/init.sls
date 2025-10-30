include:
  - pkgs.cron
  - pkgs.curl
  - pkgs.dmidecode
  {%- if grains['osrelease'] == '13`' &&  grains['osarch'] != 'arm64' %}
  - pkgs.dnsutils
  {%- else %}
  - pkgs.dnsutils
  {%- endif %}
  {%- if grains['osrelease'] == '11' %}
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
  - pkgs.make
  - pkgs.man
  - pkgs.nginx
  - pkgs.openldap
  - pkgs.openssl
  - pkgs.openssl-dev
  - pkgs.patch
  - pkgs.ping
  - pkgs.python3
  - pkgs.python3-pip
  - pkgs.rng-tools
  - pkgs.rsync
  - pkgs.sed
  - pkgs.ssh
  - pkgs.sudo
  - pkgs.swig
  - pkgs.tar
  - pkgs.zlib
  {%- if grains['osrelease'] != '13`' &&  grains['osarch'] != 'arm64' %}
  - pkgs.vault
  {%- endif %}
  - pkgs.jq
  - pkgs.xz
  - pkgs.tree
  - pkgs.cargo {#-
  - pkgs.awscli
  - pkgs.amazon-cloudwatch-agent #}
  - pkgs.samba

  {#- OS Specific packages install #}
  - .apt-utils
  - .libdpkg-perl
  - .timesync
