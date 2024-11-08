nginx:
  pkg.installed

{%- if grains["os_family"] == 'Debian' and grains.get("systemd", None) %}
{#- Debian based distributions always start services #}
disable-nginx-service:
  service.disabled:
    - name: nginx
{%- endif %}
