{%- set pkg = "passwd" %}
passwd:
  pkg.installed:
    - name: {{ pkg }}
