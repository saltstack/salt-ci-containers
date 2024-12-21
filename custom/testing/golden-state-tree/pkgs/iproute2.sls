{%- if grains['os'] == 'Rocky' %}
  {%- set pkg = "iproute" %}
{%- else %}
  {%- set pkg = "iproute2" %}
{%- endif %}

iproute2:
  pkg.installed:
    - name: {{ pkg }}
