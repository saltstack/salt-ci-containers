{%- if grains['osrelease'] != '11' %}
  {% set install_cmd = "pip3 install --break-system-packages nox" %}
{%- else %}
  {% set install_cmd = "pip3 install nox" %}
{%- endif %}

include:
  - .config
  - .pkgs

install_nox:
  cmd.run:
    - name: {{ install_cmd }}
    - require:
      - python3-pip
