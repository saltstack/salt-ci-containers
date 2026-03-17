{%- if grains['os'] == 'Rocky' and grains['osmajorrelease']|int >= 10 %}
  {%- set pkg = "shadow-utils" %}
{%- else %}
  {%- set pkg = "passwd" %}
{%- endif %}
passwd:
  pkg.installed:
    - name: {{ pkg }}
