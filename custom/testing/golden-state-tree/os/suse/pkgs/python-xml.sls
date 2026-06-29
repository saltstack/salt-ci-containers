# openSUSE ships Python XML support as a separate package
{%- if grains['osrelease'].startswith('15') %}
python3-base:
  pkg.installed
{%- elif grains.get('osmajorrelease', 0)|int >= 16 %}
python313-base-and-xml:
  pkg.installed:
    - pkgs:
      - python313-base
      - python3-xml
{%- endif %}
