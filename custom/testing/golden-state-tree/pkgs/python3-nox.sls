
{%- set pkg_name = 'python3-nox' %}

python3-nox:
  pkg.installed:
    - name: {{ pkg_name }}
