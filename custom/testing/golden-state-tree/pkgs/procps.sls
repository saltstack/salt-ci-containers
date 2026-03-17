{%- if grains['os_family'] in ('RedHat') or grains['os'] == 'VMware Photon OS' %}
  {%- set pkg = "procps-ng" %}
{%- else %}
  {%- set pkg = "procps" %}
{%- endif %}



procps:
  pkg.installed:
    - name: {{ pkg }}
