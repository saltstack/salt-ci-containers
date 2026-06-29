{%- if grains.get('os_family') == 'RedHat' and grains.get('osmajorrelease', '0') | int >= 9 %}
enable-nginx-module:
  cmd.run:
    - name: dnf module enable nginx:mainline -y
    - unless: dnf module list --enabled 2>/dev/null | grep -q nginx
{%- endif %}

nginx:
  pkg.installed:
  {%- if grains.get('os_family') == 'RedHat' and grains.get('osmajorrelease', '0') | int >= 9 %}
    - require:
      - cmd: enable-nginx-module
  {%- endif %}

{%- if grains["os_family"] == 'Debian' and grains.get("systemd", None) %}
{#- Debian based distributions always start services #}
disable-nginx-service:
  service.disabled:
    - name: nginx
{%- endif %}
