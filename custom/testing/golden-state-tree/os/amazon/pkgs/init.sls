include:
  - pkgs.cron
  - pkgs.curl
  - pkgs.dmidecode
  - pkgs.dnsutils
  - pkgs.gcc
  - pkgs.gpg
  - pkgs.git
  - pkgs.libcurl
  - pkgs.libffi
  - pkgs.libsodium
  - pkgs.libxml
  - pkgs.libxslt
  - pkgs.make
  - pkgs.man
  - pkgs.nginx
  - pkgs.openldap
  - pkgs.openssl
  - pkgs.openssl-dev
  - pkgs.passwd
  - pkgs.patch
  - pkgs.python3
  - pkgs.python3-pip
  - pkgs.rng-tools
  - pkgs.rpmdevtools
  - pkgs.rsync
  - pkgs.sed
  - pkgs.sudo
  - pkgs.ssh
  - pkgs.swig
  - pkgs.tar
  - pkgs.which
  - pkgs.zlib
  - pkgs.jq
  - pkgs.xz
  - pkgs.tree
  - pkgs.cargo {#-
  - pkgs.awscli
  - pkgs.amazon-cloudwatch-agent #}
  - pkgs.samba

  {#- OS Specific packages install #}
  - .epel-release
  {%- if grains['osarch'] not in ('amd64', 'armhf', 'arm64') %}
  {#- - .docker #}
  {%- endif %}
