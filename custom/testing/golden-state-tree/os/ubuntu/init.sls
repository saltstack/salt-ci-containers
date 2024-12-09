{%- if grains['osrelease'] in ["20.04", "22.04",] %}
  {% set install_cmd = "pip3 install nox" %}
{%- else %}
  {% set install_cmd = "pip3 install --break-system-packages nox" %}
{%- endif %}

include:
  - .config
  - .pkgs

install_nox:
  cmd.run:
    - name: {{ install_cmd }}
    - require:
      - python3-pip
