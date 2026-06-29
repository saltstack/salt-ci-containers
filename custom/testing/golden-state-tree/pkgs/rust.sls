{%- if grains['os_family'] == 'Debian' %}
  {%- set rust = 'rustc' %}
{%- else %}
  {%- set rust = 'rust' %}
{%- endif %}

{%- if grains['osarch'] != 'arm64' %}
rust:
  pkg.installed:
    - name: {{ rust }}
{%- endif %}
