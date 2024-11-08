include:
  - os.debian.pkgs.apt-utils
  - os.debian.pkgs.libdpkg-perl
  - os.debian.pkgs.timesync
  - pkgs.bower
  - pkgs.curl
  - pkgs.dmidecode
  - pkgs.dnsutils
  - pkgs.docker
  - pkgs.gcc
  - pkgs.gpg
  - pkgs.ipset
  - pkgs.libcurl
  - pkgs.libffi
  - pkgs.libgit2
  - pkgs.libsodium
  - pkgs.libxml
  - pkgs.libxslt
#  - pkgs.lxc
  - pkgs.make
  - pkgs.man
  - pkgs.nginx
  - pkgs.npm
  - pkgs.openldap
  - pkgs.openssl
  - pkgs.openssl-dev
  - pkgs.patch
  - pkgs.python3
  - pkgs.python3-pip
  - pkgs.rng-tools
  - pkgs.rsync
  - pkgs.sed
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