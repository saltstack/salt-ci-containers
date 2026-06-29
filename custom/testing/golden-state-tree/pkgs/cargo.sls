include:
  - pkgs.rust

{%- if grains['osarch'] != 'arm64' %}
cargo:
  pkg.installed
{%- endif %}
