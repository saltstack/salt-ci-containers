{%- if grains['os'] == 'SmartOS' %}
  {%- set gcc = 'gcc47' %}
{%- elif grains['os'] == 'Arch' %}
  {%- if salt['pkg.list_repo_pkgs']('gcc-multilib') %}
    {%- set gcc = 'gcc-multilib' %}
  {%- else %}
    {%- set gcc = 'gcc' %}
  {%- endif %}
{%- else %}
  {%- set gcc = 'gcc' %}
{%- endif %}

{%- if grains['os'] == 'Arch' and gcc == 'gcc' %}
gcc-multilib:
  pkg.removed
{%- endif %}

gcc:
  pkg.installed:
    - name: {{ gcc }}
{# RHEL-based systems may require --allowerasing for proper installs and upgrades #}
{%- if grains['os'] in ('Rocky',) %}
    - setopt: 'allowerasing'
{%- endif %}
{# workaround on macosx - issue when install node and gcc together #}
{%- if grains['os_family'] in ('MacOS',) %}
    - aggregate: False
{%- endif %}

{%- if grains['os'] == 'VMware Photon OS' %}
build-essential:
  pkg.installed
{%- endif %}
