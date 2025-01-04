{%- if grains['os_family'] in ('Debian',)  %}
  {%- set pkg = "inetutils-ping" %}
{%- elif grains['os_family'] in ('Redhat',)  %}
  {%- set pkg = "iputils" %}
{%- else %}
  {%- set pkg = "ping" %}
{%- endif %}

ping:
  pkg.installed:
    - name: {{ pkg }}
