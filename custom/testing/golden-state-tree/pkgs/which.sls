{%- set which = 'which' %}

which:
  pkg.installed:
    - name: {{ which }}
