{%- set os = salt['grains.get']('os', '') %}
{%- set os_family = salt['grains.get']('os_family', '') %}
{%- set os_major_release = salt['grains.get']('osmajorrelease', 0)|int %}

{%- if os_family == 'Debian' %}
  {%- set pkg_name = 'python3-nox' %}
{%- elif os == 'Fedora' %}
  {%- set pkg_name = 'nox' %}
{%- elif os == 'Arch' %}
  {%- set pkg_name = 'python-nox' %}
{%- elif os in ('CentOS', 'CentOS Stream', 'Rocky', 'AlmaLinux', 'RedHat') and os_major_release >= 8 %}
  {#- Requires EPEL #}
  {%- set pkg_name = 'python3-nox' %}
{%- else %}
  {%- set pkg_name = None %}
{%- endif %}

{%- if pkg_name %}
python3-nox:
  pkg.installed:
    - name: {{ pkg_name }}
{%- endif %}
