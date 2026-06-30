{%- if grains['os_family'] == 'RedHat' %}
  {%- set openssl_dev = 'openssl-devel' %}
{%- elif grains['os_family'] == 'Suse' and grains.get('osmajorrelease', 0)|int >= 16 %}
  {%- set openssl_dev = 'libressl-devel' %}
{%- elif grains['os_family'] == 'Suse' %}
  {%- set openssl_dev = 'libopenssl-3-devel' %}
{%- else %}
  {%- set openssl_dev = 'libssl-dev' %}
{%- endif %}

include:
  - pkgs.openssl

openssl-dev:
  pkg.installed:
    - name: {{ openssl_dev }}
    - require:
      - openssl
