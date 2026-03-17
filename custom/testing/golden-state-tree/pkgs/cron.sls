{%- if grains['os_family'] == 'Debian' %}
cron:
  pkg.installed
{%- else %}
cronie:
  pkg.installed
{%- endif %}
