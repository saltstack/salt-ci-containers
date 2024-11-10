{%- set pkg_name = 'python3-venv' %}

python3-venv:
  pkg.installed:
    - name: {{ pkg_name }}
