{%- set pkg = "ansible" %}
ansible:
  pkg.installed:
    - name: {{ pkg }}
