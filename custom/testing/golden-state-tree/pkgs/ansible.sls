{%- if grains['os'] == 'Rocky' and grains['osmajorrelease']|int >= 10 %}
  {%- set pkg = "ansible-core" %}
{%- else %}
  {%- set pkg = "ansible" %}
{%- endif %}
ansible:
  pkg.installed:
    - name: {{ pkg }}
