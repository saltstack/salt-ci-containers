# Install dnf config manager
install_config_command:
  cmd.run:
    - name: dnf install -y 'dnf-command(config-manager)'


{%- if grains['lsb_distrib_release'].startswith("9") %}
# Use config manager to enable powertools repo. This is needed for libnsl2-devel
enable_devel_repo:
  cmd.run:
    - name: dnf config-manager --set-enabled devel
    - require:
      - install_config_command
{%- else %}
# Use config manager to enable powertools repo. This is needed for libnsl2-devel
enable_powertools_repo:
  cmd.run:
    - name: dnf config-manager --set-enabled powertools
    - require:
      - install_config_command
{% endif %}


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
{%- if grains['lsb_distrib_release'].startswith("9") %}
       - enable_devel_repo
{%- else %}
       - enable_powertools_repo
{% endif %}

{%- if grains['lsb_distrib_release'].startswith("9") %}
# Use config manager to enable powertools repo. This is needed for libnsl2-devel
disable_devel_repo:
  cmd.run:
    - name: dnf config-manager --set-disabled devel
    - require:
      - python_dependencies
{%- endif %}
