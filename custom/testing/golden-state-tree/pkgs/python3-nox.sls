{%- set os = salt['grains.get']('os', '') %}
{%- set os_family = salt['grains.get']('os_family', '') %}
{%- set os_major_release = salt['grains.get']('osmajorrelease', 0)|int %}

{%- if os_family == 'Debian' %}
  {%- if os == 'Ubuntu' and os_major_release >= 24 %}
    {%- set pkg_name = 'nox' %}
  {%- elif os == 'Debian' and os_major_release >= 13 %}
    {%- set pkg_name = 'nox' %}
  {%- else %}
    {%- set pkg_name = 'python3-nox' %}
  {%- endif %}
{%- elif os == 'Fedora' %}
  {%- set pkg_name = 'nox' %}
{%- elif os == 'Arch' %}
  {%- set pkg_name = 'python-nox' %}
{%- else %}
  {%- set pkg_name = None %}
{%- endif %}

{%- if pkg_name %}
python3-nox:
  pkg.installed:
    - name: {{ pkg_name }}
{%- endif %}
