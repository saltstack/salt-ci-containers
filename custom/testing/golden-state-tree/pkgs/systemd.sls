{%- set pkg_name = "systemd" -%}
systemd:
  pkg.installed:
    - name: {{ pkg_name }}
