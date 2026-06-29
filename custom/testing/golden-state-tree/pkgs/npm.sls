{%- set suse = True if grains['os_family'] == 'Suse' else False %}
{%- set freebsd = True if grains['os'] == 'FreeBSD' else False %}
{%- set ubuntu = True if grains['os'] == 'Ubuntu' else False %}
{%- set macos = True if grains['os'] == 'MacOS' else False %}
{%- set photon = True if grains['os'] == 'VMware Photon OS' else False %}

# Suse does not package npm separately
{%- if suse and grains.get('osmajorrelease', 0)|int >= 16 %}
  {%- set npm = 'npm22' %}
  {%- set nodejs = 'nodejs22' %}
{%- elif suse %}
  {%- set npm = 'npm20' %}
  {%- set nodejs = 'nodejs20' %}
{%- elif ubuntu %}
  {%- set npm = 'npm' %}
  {%- set nodejs = 'nodejs' %}
{%- elif freebsd %}
  {%- set npm = 'www/npm' %}
{%- elif macos %}
  {%- set npm = 'node' %}
{%- elif photon %}
  {%- set npm = 'nodejs' %}
{%- else %}
  {%- set npm = 'npm' %}
{%- endif %}

npm:
  pkg.installed:
    - pkgs:
    {%- if suse or ubuntu %}
      - {{ nodejs }}
    {%- endif %}
      - {{ npm }}
