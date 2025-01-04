{%- if grains['os_family'] == 'Debian'  %}
  {%- set pkg = "inetutils-ping" %}
{%- elif grains['os_family'] == 'Redhat'  %}
  {%- set pkg = "iputils" %}
{%- else %}
  {%- set pkg = "ping" %}
{%- endif %}

ping:
  pkg.installed:
    - name: {{ pkg }}
