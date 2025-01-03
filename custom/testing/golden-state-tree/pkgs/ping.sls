{%- if grains['os_family'] in ('Debian',)  %}
  {%- set pkg = "inetutils-ping" %}
{%- else %}
  {%- set pkg = "ping" %}
{%- endif %}

ping:
  pkg.installed:
    - name: {{ pkg }}
